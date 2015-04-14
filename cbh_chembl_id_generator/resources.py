from tastypie import fields
from tastypie.resources import Resource
from tastypie.authorization import Authorization
from cbh_chembl_id_generator.models import CBHCompoundId


def generate_uox_id():
    two_letterg = shortuuid.ShortUUID()
    two_letterg.set_alphabet("ABCDEFGHJKLMNPQRSTUVWXYZ")
    two_letter = two_letterg.random(length=2)
    two_numberg = shortuuid.ShortUUID()
    two_numberg.set_alphabet("0123456789")
    two_number = two_numberg.random(length=2)
    three_letterg = shortuuid.ShortUUID()
    three_letterg.set_alphabet("ABCDEFGHJKLMNPQRSTUVWXYZ")
    three_letter = three_letterg.random(length=3)
    uox_id = "%s%s%s%s" % (settings.ID_PREFIX ,two_letter, two_number, three_letter )
    try:
        CBHCompoundId.objects.get(assigned_id=uox_id)
        return generate_uox_id()
    except  ObjectDoesNotExist:
        return uox_id


class CBHCompoundIdResource(ModelResource):
    """web service for accessing Compound Ids
    Request without an inchi key will be considered a request for a blinded ID or a forced new ID in that project and installation_key
    Request with and inchi key - inchi will be saved if it is public 
    Inchi will not be saved if it is private
    """=    
    inchi_key = fields.CharField(attribute='inchi_key', required=False)



    class Meta:
        resource_name = 'cbh_compound_ids'
        authorization = Authorization()
        always_return_data = True
        collection_name = "objects"
        allowed_methods =["post", "patch"]



    def patch_list(self, request, **kwargs):
        """
        Updates a collection in-place.
        The exact behavior of ``PATCH`` to a list resource is still the matter of
        some debate in REST circles, and the ``PATCH`` RFC isn't standard. So the
        behavior this method implements (described below) is something of a
        stab in the dark. It's mostly cribbed from GData, with a smattering
        of ActiveResource-isms and maybe even an original idea or two.
        The ``PATCH`` format is one that's similar to the response returned from
        a ``GET`` on a list resource::
            {
              "objects": [{object}, {object}, ...],
              "deleted_objects": ["URI", "URI", "URI", ...],
            }
        For each object in ``objects``:
            * If the dict does not have a ``resource_uri`` key then the item is
              considered "new" and is handled like a ``POST`` to the resource list.
            * If the dict has a ``resource_uri`` key and the ``resource_uri`` refers
              to an existing resource then the item is a update; it's treated
              like a ``PATCH`` to the corresponding resource detail.
            * If the dict has a ``resource_uri`` but the resource *doesn't* exist,
              then this is considered to be a create-via-``PUT``.
        Each entry in ``deleted_objects`` referes to a resource URI of an existing
        resource to be deleted; each is handled like a ``DELETE`` to the relevent
        resource.
        In any case:
            * If there's a resource URI it *must* refer to a resource of this
              type. It's an error to include a URI of a different resource.
            * ``PATCH`` is all or nothing. If a single sub-operation fails, the
              entire request will fail and all resources will be rolled back.
          * For ``PATCH`` to work, you **must** have ``put`` in your
            :ref:`detail-allowed-methods` setting.
          * To delete objects via ``deleted_objects`` in a ``PATCH`` request you
            **must** have ``delete`` in your :ref:`detail-allowed-methods`
            setting.
        Substitute appropriate names for ``objects`` and
        ``deleted_objects`` if ``Meta.collection_name`` is set to something
        other than ``objects`` (default).
        """
        request = convert_post_to_patch(request)
        deserialized = self.deserialize(request, request.body, format=request.META.get('CONTENT_TYPE', 'application/json'))

        collection_name = self._meta.collection_name

        if collection_name not in deserialized:
            raise BadRequest("Invalid data sent: missing '%s'" % collection_name)

        if len(deserialized[collection_name]) and 'put' not in self._meta.detail_allowed_methods:
            raise ImmediateHttpResponse(response=http.HttpMethodNotAllowed())

        bundles_seen = []

        for data in deserialized[collection_name]:
            # If there's a resource_uri then this is either an
            # update-in-place or a create-via-PUT.
            if "assigned_id" in data:
                raise BadRequest("Assigned ID must not be set, this API is for creating new IDs")
            if "inchi_key" in data:
                inchi_key = data.pop('inchi_key')
                try:
                    obj = CBHCompoundId.objects.get(structure_key=inchi_key)

                    # The object does exist, so we return the original object with the original ID
                    bundle = self.build_bundle(obj=obj, request=request)
                    bundle = self.full_dehydrate(bundle, for_list=True)
                    bundle = self.alter_detail_data_to_serialize(request, bundle)
                    #self.update_in_place(request, bundle, data)
                except (ObjectDoesNotExist, MultipleObjectsReturned):
                    # The object does not exist so we create it
                    data = self.alter_deserialized_detail_data(request, data)
                    bundle = self.build_bundle(data=dict_strip_unicode_keys(data), request=request)
                    self.obj_create(bundle=bundle)
            else:
                # There's no resource URI, so this is a create call just
                # like a POST to the list resource.
                data = self.alter_deserialized_detail_data(request, data)
                bundle = self.build_bundle(data=dict_strip_unicode_keys(data), request=request)
                self.obj_create(bundle=bundle)

            bundles_seen.append(bundle)

      
        if not self._meta.always_return_data:
            return http.HttpAccepted()
        else:
            to_be_serialized = {}
            to_be_serialized['objects'] = [self.full_dehydrate(bundle, for_list=True) for bundle in bundles_seen]
            to_be_serialized = self.alter_list_data_to_serialize(request, to_be_serialized)
            return self.create_response(request, to_be_serialized, response_class=http.HttpAccepted)


    def alter_deserialized_detail_data(request, data):
        '''Make our request data into the right format to be saved'''
        data["assigned_id"] = generate_uox_id()
        if data.get("inchi_key", None):
            data["structure_key"] = data.pop("inchi_key")
        else:
            data["structure_key"] = data["assigned_id"]
        return data
