--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE activities (
    activity_id bigint NOT NULL,
    assay_id integer NOT NULL,
    doc_id integer,
    record_id integer NOT NULL,
    molregno integer,
    standard_relation character varying(50),
    published_value numeric,
    published_units character varying(100),
    standard_value numeric,
    standard_units character varying(100),
    standard_flag smallint,
    standard_type character varying(250),
    activity_comment character varying(4000),
    published_type character varying(250),
    data_validity_comment character varying(30),
    potential_duplicate smallint,
    published_relation character varying(50),
    pchembl_value numeric(4,2),
    bao_endpoint character varying(11),
    uo_units character varying(10),
    qudt_units character varying(70),
    CONSTRAINT activities_potential_duplicate_check CHECK (((potential_duplicate = ANY (ARRAY[0, 1])) OR (potential_duplicate IS NULL))),
    CONSTRAINT activities_standard_flag_check CHECK (((standard_flag = ANY (ARRAY[0, 1])) OR (standard_flag IS NULL)))
);


ALTER TABLE public.activities OWNER TO postgres;

--
-- Name: COLUMN activities.activity_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.activity_id IS 'Unique ID for the activity row';


--
-- Name: COLUMN activities.assay_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.assay_id IS 'Foreign key to the assays table (containing the assay description)';


--
-- Name: COLUMN activities.doc_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.doc_id IS 'Foreign key to documents table (for quick lookup of publication details - can also link to documents through compound_records or assays table)';


--
-- Name: COLUMN activities.record_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.record_id IS 'Foreign key to the compound_records table (containing information on the compound tested)';


--
-- Name: COLUMN activities.molregno; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.molregno IS 'Foreign key to compounds table (for quick lookup of compound structure - can also link to compounds through compound_records table)';


--
-- Name: COLUMN activities.standard_relation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.standard_relation IS 'Symbol constraining the activity value (e.g. >, <, =)';


--
-- Name: COLUMN activities.published_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.published_value IS 'Datapoint value as it appears in the original publication.';


--
-- Name: COLUMN activities.published_units; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.published_units IS 'Units of measurement as they appear in the original publication';


--
-- Name: COLUMN activities.standard_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.standard_value IS 'Same as PUBLISHED_VALUE but transformed to common units: e.g. mM concentrations converted to nM.';


--
-- Name: COLUMN activities.standard_units; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.standard_units IS 'Selected ''Standard'' units for data type: e.g. concentrations are in nM.';


--
-- Name: COLUMN activities.standard_flag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.standard_flag IS 'Shows whether the standardised columns have been curated/set (1) or just default to the published data (0).';


--
-- Name: COLUMN activities.standard_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.standard_type IS 'Standardised version of the published_activity_type (e.g. IC50 rather than Ic-50/Ic50/ic50/ic-50)';


--
-- Name: COLUMN activities.activity_comment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.activity_comment IS 'Describes non-numeric activities i.e. ''Slighty active'', ''Not determined''';


--
-- Name: COLUMN activities.published_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.published_type IS 'Type of end-point measurement: e.g. IC50, LD50, %%inhibition etc, as it appears in the original publication';


--
-- Name: COLUMN activities.data_validity_comment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.data_validity_comment IS 'Comment reflecting whether the values for this activity measurement are likely to be correct - one of ''Manually validated'' (checked original paper and value is correct), ''Potential author error'' (value looks incorrect but is as reported in the original paper), ''Outside typical range'' (value seems too high/low to be correct e.g., negative IC50 value), ''Non standard unit type'' (units look incorrect for this activity type).';


--
-- Name: COLUMN activities.potential_duplicate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.potential_duplicate IS 'Indicates whether the value is likely to be a repeat citation of a value reported in a previous ChEMBL paper, rather than a new, independent measurement.';


--
-- Name: COLUMN activities.published_relation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.published_relation IS 'Symbol constraining the activity value (e.g. >, <, =), as it appears in the original publication';


--
-- Name: COLUMN activities.pchembl_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.pchembl_value IS 'Negative log of selected concentration-response activity values (IC50/EC50/XC50/AC50/Ki/Kd/Potency)';


--
-- Name: COLUMN activities.bao_endpoint; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.bao_endpoint IS 'ID for the corresponding result type in BioAssay Ontology (based on standard_type)';


--
-- Name: COLUMN activities.uo_units; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.uo_units IS 'ID for the corresponding unit in Unit Ontology (based on standard_units)';


--
-- Name: COLUMN activities.qudt_units; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN activities.qudt_units IS 'ID for the corresponding unit in QUDT Ontology (based on standard_units)';


--
-- Name: assays; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE assays (
    assay_id integer NOT NULL,
    doc_id integer NOT NULL,
    description character varying(4000),
    assay_type character varying(1),
    assay_test_type character varying(20),
    assay_category character varying(20),
    assay_organism character varying(250),
    assay_tax_id bigint,
    assay_strain character varying(200),
    assay_tissue character varying(100),
    assay_cell_type character varying(100),
    assay_subcellular_fraction character varying(100),
    tid integer,
    relationship_type character varying(1),
    confidence_score smallint,
    curated_by character varying(32),
    src_id smallint NOT NULL,
    src_assay_id character varying(50),
    chembl_id character varying(20) NOT NULL,
    cell_id integer,
    bao_format character varying(11),
    CONSTRAINT assays_assay_category_check CHECK (((assay_category)::text = ANY (ARRAY[('screening'::character varying)::text, ('panel'::character varying)::text, ('confirmatory'::character varying)::text, ('summary'::character varying)::text, ('other'::character varying)::text]))),
    CONSTRAINT assays_assay_tax_id_check CHECK ((assay_tax_id >= 0)),
    CONSTRAINT assays_assay_test_type_check CHECK (((assay_test_type)::text = ANY (ARRAY[('In vivo'::character varying)::text, ('In vitro'::character varying)::text, ('Ex vivo'::character varying)::text]))),
    CONSTRAINT assays_confidence_score_check CHECK ((confidence_score >= 0))
);


ALTER TABLE public.assays OWNER TO postgres;

--
-- Name: COLUMN assays.assay_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_id IS 'Unique ID for the assay';


--
-- Name: COLUMN assays.doc_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.doc_id IS 'Foreign key to documents table';


--
-- Name: COLUMN assays.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.description IS 'Description of the reported assay';


--
-- Name: COLUMN assays.assay_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_type IS 'Assay classification, e.g. B=Binding assay, A=ADME assay, F=Functional assay';


--
-- Name: COLUMN assays.assay_test_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_test_type IS 'Type of assay system (i.e., in vivo or in vitro)';


--
-- Name: COLUMN assays.assay_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_category IS 'screening, confirmatory (ie: dose-response), summary, panel or other.';


--
-- Name: COLUMN assays.assay_organism; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_organism IS 'Name of the organism for the assay system (e.g., the organism, tissue or cell line in which an assay was performed). May differ from the target organism (e.g., for a human protein expressed in non-human cells, or pathogen-infected human cells).';


--
-- Name: COLUMN assays.assay_tax_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_tax_id IS 'NCBI tax ID for the assay organism.';


--
-- Name: COLUMN assays.assay_strain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_strain IS 'Name of specific strain of the assay organism used (where known)';


--
-- Name: COLUMN assays.assay_tissue; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_tissue IS 'Name of tissue used in the assay system (e.g., for tissue-based assays) or from which the assay system was derived (e.g., for cell/subcellular fraction-based assays).';


--
-- Name: COLUMN assays.assay_cell_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_cell_type IS 'Name of cell type or cell line used in the assay system (e.g., for cell-based assays).';


--
-- Name: COLUMN assays.assay_subcellular_fraction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.assay_subcellular_fraction IS 'Name of subcellular fraction used in the assay system (e.g., microsomes, mitochondria).';


--
-- Name: COLUMN assays.tid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.tid IS 'Target identifier to which this assay has been mapped. Foreign key to target_dictionary. From ChEMBL_15 onwards, an assay will have only a single target assigned.';


--
-- Name: COLUMN assays.relationship_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.relationship_type IS 'Flag indicating of the relationship between the reported target in the source document and the assigned target from TARGET_DICTIONARY. Foreign key to RELATIONSHIP_TYPE table.';


--
-- Name: COLUMN assays.confidence_score; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.confidence_score IS 'Confidence score, indicating how accurately the assigned target(s) represents the actually assay target. Foreign key to CONFIDENCE_SCORE table. 0 means uncurated/unassigned, 1 = low confidence to 9 = high confidence.';


--
-- Name: COLUMN assays.curated_by; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.curated_by IS 'Indicates the level of curation of the target assignment. Foreign key to curation_lookup table.';


--
-- Name: COLUMN assays.src_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.src_id IS 'Foreign key to source table';


--
-- Name: COLUMN assays.src_assay_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.src_assay_id IS 'Identifier for the assay in the source database/deposition (e.g., pubchem AID)';


--
-- Name: COLUMN assays.chembl_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.chembl_id IS 'ChEMBL identifier for this assay (for use on web interface etc)';


--
-- Name: COLUMN assays.cell_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.cell_id IS 'Foreign key to cell dictionary. The cell type or cell line used in the assay';


--
-- Name: COLUMN assays.bao_format; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN assays.bao_format IS 'ID for the corresponding format type in BioAssay Ontology (e.g., cell-based, biochemical, organism-based etc)';


--
-- Name: binding_sites; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE binding_sites (
    site_id integer NOT NULL,
    site_name character varying(200),
    tid integer
);


ALTER TABLE public.binding_sites OWNER TO postgres;

--
-- Name: COLUMN binding_sites.site_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN binding_sites.site_id IS 'Primary key. Unique identifier for a binding site in a given target.';


--
-- Name: COLUMN binding_sites.site_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN binding_sites.site_name IS 'Name/label for the binding site.';


--
-- Name: COLUMN binding_sites.tid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN binding_sites.tid IS 'Foreign key to target_dictionary. Target on which the binding site is found.';


--
-- Name: compound_records; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE compound_records (
    record_id integer NOT NULL,
    molregno integer,
    doc_id integer NOT NULL,
    compound_key character varying(250),
    compound_name character varying(4000),
    src_id smallint NOT NULL,
    src_compound_id character varying(150)
);


ALTER TABLE public.compound_records OWNER TO postgres;

--
-- Name: COLUMN compound_records.record_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_records.record_id IS 'Unique ID for a compound/record';


--
-- Name: COLUMN compound_records.molregno; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_records.molregno IS 'Foreign key to compounds table (compound structure)';


--
-- Name: COLUMN compound_records.doc_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_records.doc_id IS 'Foreign key to documents table';


--
-- Name: COLUMN compound_records.compound_key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_records.compound_key IS 'Key text identifying this compound in the scientific document';


--
-- Name: COLUMN compound_records.compound_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_records.compound_name IS 'Name of this compound recorded in the scientific document';


--
-- Name: COLUMN compound_records.src_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_records.src_id IS 'Foreign key to source table';


--
-- Name: COLUMN compound_records.src_compound_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_records.src_compound_id IS 'Identifier for the compound in the source database (e.g., pubchem SID)';


--
-- Name: compound_structures; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE compound_structures (
    molregno integer NOT NULL,
    molfile text,
    standard_inchi character varying(4000),
    standard_inchi_key character varying(27) NOT NULL,
    canonical_smiles character varying(4000)
);


ALTER TABLE public.compound_structures OWNER TO postgres;

--
-- Name: COLUMN compound_structures.molregno; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_structures.molregno IS 'Internal Primary Key for the compound structure and foreign key to molecule_dictionary table';


--
-- Name: COLUMN compound_structures.molfile; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_structures.molfile IS 'MDL Connection table representation of compound';


--
-- Name: COLUMN compound_structures.standard_inchi; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_structures.standard_inchi IS 'IUPAC standard InChI for the compound';


--
-- Name: COLUMN compound_structures.standard_inchi_key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_structures.standard_inchi_key IS 'IUPAC standard InChI key for the compound';


--
-- Name: COLUMN compound_structures.canonical_smiles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN compound_structures.canonical_smiles IS 'Canonical smiles, generated using pipeline pilot';


--
-- Name: docs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE docs (
    doc_id integer NOT NULL,
    journal character varying(50),
    year smallint,
    volume character varying(50),
    issue character varying(50),
    first_page character varying(50),
    last_page character varying(50),
    pubmed_id bigint,
    doi character varying(50),
    chembl_id character varying(20) NOT NULL,
    title character varying(500),
    doc_type character varying(50) NOT NULL,
    authors character varying(4000),
    abstract text,
    CONSTRAINT docs_doc_type_check CHECK (((doc_type)::text = ANY (ARRAY[('PUBLICATION'::character varying)::text, ('BOOK'::character varying)::text, ('DATASET'::character varying)::text]))),
    CONSTRAINT docs_pubmed_id_check CHECK ((pubmed_id >= 0)),
    CONSTRAINT docs_year_check CHECK ((year >= 0))
);


ALTER TABLE public.docs OWNER TO postgres;

--
-- Name: COLUMN docs.doc_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.doc_id IS 'Unique ID for the document';


--
-- Name: COLUMN docs.journal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.journal IS 'Abbreviated journal name for an article';


--
-- Name: COLUMN docs.year; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.year IS 'Year of journal article publication';


--
-- Name: COLUMN docs.volume; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.volume IS 'Volume of journal article';


--
-- Name: COLUMN docs.issue; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.issue IS 'Issue of journal article';


--
-- Name: COLUMN docs.first_page; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.first_page IS 'First page number of journal article';


--
-- Name: COLUMN docs.last_page; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.last_page IS 'Last page number of journal article';


--
-- Name: COLUMN docs.pubmed_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.pubmed_id IS 'NIH pubmed record ID, where available';


--
-- Name: COLUMN docs.doi; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.doi IS 'Digital object identifier for this reference';


--
-- Name: COLUMN docs.chembl_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.chembl_id IS 'ChEMBL identifier for this document (for use on web interface etc)';


--
-- Name: COLUMN docs.title; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.title IS 'Document title (e.g., Publication title or description of dataset)';


--
-- Name: COLUMN docs.doc_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.doc_type IS 'Type of the document (e.g., Publication, Deposited dataset)';


--
-- Name: COLUMN docs.authors; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.authors IS 'For a deposited dataset, the authors carrying out the screening and/or submitting the dataset.';


--
-- Name: COLUMN docs.abstract; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN docs.abstract IS 'For a deposited dataset, a brief description of the dataset.';


--
-- Name: molecule_dictionary; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE molecule_dictionary (
    molregno integer NOT NULL,
    pref_name character varying(255),
    chembl_id character varying(20) NOT NULL,
    max_phase smallint DEFAULT 0 NOT NULL,
    therapeutic_flag smallint DEFAULT 0 NOT NULL,
    dosed_ingredient smallint DEFAULT 0 NOT NULL,
    structure_type character varying(10) NOT NULL,
    chebi_par_id integer,
    molecule_type character varying(30),
    first_approval smallint,
    oral smallint DEFAULT 0 NOT NULL,
    parenteral smallint DEFAULT 0 NOT NULL,
    topical smallint DEFAULT 0 NOT NULL,
    black_box_warning smallint DEFAULT 0 NOT NULL,
    natural_product smallint DEFAULT (-1) NOT NULL,
    first_in_class smallint DEFAULT (-1) NOT NULL,
    chirality smallint DEFAULT (-1) NOT NULL,
    prodrug smallint DEFAULT (-1) NOT NULL,
    inorganic_flag smallint DEFAULT 0 NOT NULL,
    usan_year smallint,
    availability_type smallint,
    usan_stem character varying(50),
    polymer_flag smallint,
    usan_substem character varying(50),
    usan_stem_definition character varying(1000),
    indication_class character varying(1000),
    CONSTRAINT molecule_dictionary_availability_type_check CHECK ((availability_type = ANY (ARRAY[(-1), 0, 1, 2]))),
    CONSTRAINT molecule_dictionary_black_box_warning_check CHECK ((black_box_warning = ANY (ARRAY[0, 1, (-1)]))),
    CONSTRAINT molecule_dictionary_chebi_par_id_check CHECK ((chebi_par_id >= 0)),
    CONSTRAINT molecule_dictionary_chirality_check CHECK ((chirality = ANY (ARRAY[(-1), 0, 1, 2]))),
    CONSTRAINT molecule_dictionary_dosed_ingredient_check CHECK ((dosed_ingredient = ANY (ARRAY[0, 1]))),
    CONSTRAINT molecule_dictionary_first_approval_check CHECK ((first_approval >= 0)),
    CONSTRAINT molecule_dictionary_first_in_class_check CHECK ((first_in_class = ANY (ARRAY[0, 1, (-1)]))),
    CONSTRAINT molecule_dictionary_inorganic_flag_check CHECK ((inorganic_flag = ANY (ARRAY[0, 1, (-1)]))),
    CONSTRAINT molecule_dictionary_max_phase_check CHECK (((max_phase >= 0) AND (max_phase = ANY (ARRAY[0, 1, 2, 3, 4])))),
    CONSTRAINT molecule_dictionary_molecule_type_check CHECK (((molecule_type)::text = ANY (ARRAY[('Antibody'::character varying)::text, ('Cell'::character varying)::text, ('Enzyme'::character varying)::text, ('Oligonucleotide'::character varying)::text, ('Oligosaccharide'::character varying)::text, ('Protein'::character varying)::text, ('Small molecule'::character varying)::text, ('Unclassified'::character varying)::text, ('Unknown'::character varying)::text]))),
    CONSTRAINT molecule_dictionary_natural_product_check CHECK ((natural_product = ANY (ARRAY[0, 1, (-1)]))),
    CONSTRAINT molecule_dictionary_oral_check CHECK ((oral = ANY (ARRAY[0, 1]))),
    CONSTRAINT molecule_dictionary_parenteral_check CHECK ((parenteral = ANY (ARRAY[0, 1]))),
    CONSTRAINT molecule_dictionary_polymer_flag_check CHECK (((polymer_flag = ANY (ARRAY[0, 1])) OR (polymer_flag IS NULL))),
    CONSTRAINT molecule_dictionary_prodrug_check CHECK ((prodrug = ANY (ARRAY[0, 1, (-1)]))),
    CONSTRAINT molecule_dictionary_structure_type_check CHECK (((structure_type)::text = ANY (ARRAY[('NONE'::character varying)::text, ('MOL'::character varying)::text, ('SEQ'::character varying)::text, ('BOTH'::character varying)::text]))),
    CONSTRAINT molecule_dictionary_therapeutic_flag_check CHECK ((therapeutic_flag = ANY (ARRAY[0, 1]))),
    CONSTRAINT molecule_dictionary_topical_check CHECK ((topical = ANY (ARRAY[0, 1]))),
    CONSTRAINT molecule_dictionary_usan_year_check CHECK ((usan_year >= 0))
);


ALTER TABLE public.molecule_dictionary OWNER TO postgres;

--
-- Name: COLUMN molecule_dictionary.molregno; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.molregno IS 'Internal Primary Key for the molecule';


--
-- Name: COLUMN molecule_dictionary.pref_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.pref_name IS 'Preferred name for the molecule';


--
-- Name: COLUMN molecule_dictionary.chembl_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.chembl_id IS 'ChEMBL identifier for this compound (for use on web interface etc)';


--
-- Name: COLUMN molecule_dictionary.max_phase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.max_phase IS 'Maximum phase of development reached for the compound (4 = approved). Null where max phase has not yet been assigned.';


--
-- Name: COLUMN molecule_dictionary.therapeutic_flag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.therapeutic_flag IS 'Indicates that a drug has a therapeutic application (as opposed to e.g., an imaging agent, additive etc).';


--
-- Name: COLUMN molecule_dictionary.dosed_ingredient; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.dosed_ingredient IS 'Indicates that the drug is dosed in this form (e.g., a particular salt)';


--
-- Name: COLUMN molecule_dictionary.structure_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.structure_type IS 'Indications whether the molecule has a small molecule structure or a protein sequence (MOL indicates an entry in the compound_structures table, SEQ indications an entry in the protein_therapeutics table, NONE indicates an entry in neither table, e.g., structure unknown)';


--
-- Name: COLUMN molecule_dictionary.chebi_par_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.chebi_par_id IS 'Preferred ChEBI ID for the compound (where different from assigned)';


--
-- Name: COLUMN molecule_dictionary.molecule_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.molecule_type IS 'Type of molecule (Small molecule, Protein, Antibody, Oligosaccharide, Oligonucleotide, Cell, Unknown)';


--
-- Name: COLUMN molecule_dictionary.first_approval; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.first_approval IS 'Earliest known approval year for the molecule';


--
-- Name: COLUMN molecule_dictionary.oral; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.oral IS 'Indicates whether the drug is known to be administered orally.';


--
-- Name: COLUMN molecule_dictionary.parenteral; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.parenteral IS 'Indicates whether the drug is known to be administered parenterally';


--
-- Name: COLUMN molecule_dictionary.topical; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.topical IS 'Indicates whether the drug is known to be administered topically.';


--
-- Name: COLUMN molecule_dictionary.black_box_warning; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.black_box_warning IS 'Indicates that the drug has a black box warning';


--
-- Name: COLUMN molecule_dictionary.natural_product; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.natural_product IS 'Indicates whether the compound is natural product-derived (currently curated only for drugs)';


--
-- Name: COLUMN molecule_dictionary.first_in_class; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.first_in_class IS 'Indicates whether this is known to be the first compound of its class (e.g., acting on a particular target).';


--
-- Name: COLUMN molecule_dictionary.chirality; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.chirality IS 'Shows whether a drug is dosed as a racemic mixture (0), single stereoisomer (1) or is an achiral molecule (2)';


--
-- Name: COLUMN molecule_dictionary.prodrug; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.prodrug IS 'Indicates that the molecule is a pro-drug (see molecule hierarchy for active component, where known)';


--
-- Name: COLUMN molecule_dictionary.inorganic_flag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.inorganic_flag IS 'Indicates whether the molecule is inorganic (i.e., containing only metal atoms and <2 carbon atoms)';


--
-- Name: COLUMN molecule_dictionary.usan_year; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.usan_year IS 'The year in which the application for a USAN/INN name was made';


--
-- Name: COLUMN molecule_dictionary.availability_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.availability_type IS 'The availability type for the drug (0 = discontinued, 1 = prescription only, 2 = over the counter)';


--
-- Name: COLUMN molecule_dictionary.usan_stem; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.usan_stem IS 'Where the compound has been assigned a USAN name, this indicates the stem, as described in the USAN_STEM table.';


--
-- Name: COLUMN molecule_dictionary.polymer_flag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.polymer_flag IS 'Indicates whether a molecule is a small molecule polymer (e.g., polistyrex)';


--
-- Name: COLUMN molecule_dictionary.usan_substem; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.usan_substem IS 'Where the compound has been assigned a USAN name, this indicates the substem';


--
-- Name: COLUMN molecule_dictionary.usan_stem_definition; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.usan_stem_definition IS 'Definition of the USAN stem';


--
-- Name: COLUMN molecule_dictionary.indication_class; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN molecule_dictionary.indication_class IS 'Indication class(es) assigned to a drug in the USP dictionary';


--
-- Name: predicted_binding_domains; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE predicted_binding_domains (
    predbind_id integer NOT NULL,
    activity_id bigint,
    site_id integer,
    prediction_method character varying(50),
    confidence character varying(10),
    CONSTRAINT predicted_binding_domains_confidence_check CHECK (((confidence)::text = ANY (ARRAY[('high'::character varying)::text, ('medium'::character varying)::text, ('low'::character varying)::text]))),
    CONSTRAINT predicted_binding_domains_prediction_method_check CHECK (((prediction_method)::text = ANY (ARRAY[('Manual'::character varying)::text, ('Multi domain'::character varying)::text, ('Single domain'::character varying)::text])))
);


ALTER TABLE public.predicted_binding_domains OWNER TO postgres;

--
-- Name: COLUMN predicted_binding_domains.predbind_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN predicted_binding_domains.predbind_id IS 'Primary key.';


--
-- Name: COLUMN predicted_binding_domains.activity_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN predicted_binding_domains.activity_id IS 'Foreign key to the activities table, indicating the compound/assay(+target) combination for which this prediction is made.';


--
-- Name: COLUMN predicted_binding_domains.site_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN predicted_binding_domains.site_id IS 'Foreign key to the binding_sites table, indicating the binding site (domain) that the compound is predicted to bind to.';


--
-- Name: COLUMN predicted_binding_domains.prediction_method; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN predicted_binding_domains.prediction_method IS 'The method used to assign the binding domain (e.g., ''Single domain'' where the protein has only 1 domain, ''Multi domain'' where the protein has multiple domains, but only 1 is known to bind small molecules in other proteins).';


--
-- Name: COLUMN predicted_binding_domains.confidence; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN predicted_binding_domains.confidence IS 'The level of confidence assigned to the prediction (high where the protein has only 1 domain, medium where the compound has multiple domains, but only 1 known small molecule-binding domain).';


--
-- Name: site_components; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE site_components (
    sitecomp_id integer NOT NULL,
    site_id integer NOT NULL,
    component_id integer,
    domain_id integer,
    site_residues character varying(2000)
);


ALTER TABLE public.site_components OWNER TO postgres;

--
-- Name: COLUMN site_components.sitecomp_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN site_components.sitecomp_id IS 'Primary key.';


--
-- Name: COLUMN site_components.site_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN site_components.site_id IS 'Foreign key to binding_sites table.';


--
-- Name: COLUMN site_components.component_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN site_components.component_id IS 'Foreign key to the component_sequences table, indicating which molecular component of the target is involved in the binding site.';


--
-- Name: COLUMN site_components.domain_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN site_components.domain_id IS 'Foreign key to the domains table, indicating which domain of the given molecular component is involved in the binding site (where not known, the domain_id may be null).';


--
-- Name: COLUMN site_components.site_residues; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN site_components.site_residues IS 'List of residues from the given molecular component that make up the binding site (where not know, will be null).';


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (activity_id);


--
-- Name: assays_chembl_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY assays
    ADD CONSTRAINT assays_chembl_id_key UNIQUE (chembl_id);


--
-- Name: assays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY assays
    ADD CONSTRAINT assays_pkey PRIMARY KEY (assay_id);


--
-- Name: binding_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY binding_sites
    ADD CONSTRAINT binding_sites_pkey PRIMARY KEY (site_id);


--
-- Name: compound_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY compound_records
    ADD CONSTRAINT compound_records_pkey PRIMARY KEY (record_id);


--
-- Name: compound_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY compound_structures
    ADD CONSTRAINT compound_structures_pkey PRIMARY KEY (molregno);


--
-- Name: docs_chembl_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY docs
    ADD CONSTRAINT docs_chembl_id_key UNIQUE (chembl_id);


--
-- Name: docs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY docs
    ADD CONSTRAINT docs_pkey PRIMARY KEY (doc_id);


--
-- Name: docs_pubmed_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY docs
    ADD CONSTRAINT docs_pubmed_id_key UNIQUE (pubmed_id);


--
-- Name: molecule_dictionary_chembl_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY molecule_dictionary
    ADD CONSTRAINT molecule_dictionary_chembl_id_key UNIQUE (chembl_id);


--
-- Name: molecule_dictionary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY molecule_dictionary
    ADD CONSTRAINT molecule_dictionary_pkey PRIMARY KEY (molregno);


--
-- Name: predicted_binding_domains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY predicted_binding_domains
    ADD CONSTRAINT predicted_binding_domains_pkey PRIMARY KEY (predbind_id);


--
-- Name: site_components_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site_components
    ADD CONSTRAINT site_components_pkey PRIMARY KEY (sitecomp_id);


--
-- Name: site_components_site_id_component_id_domain_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site_components
    ADD CONSTRAINT site_components_site_id_component_id_domain_id_key UNIQUE (site_id, component_id, domain_id);


--
-- Name: activities_assay_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_assay_id ON activities USING btree (assay_id);


--
-- Name: activities_data_validity_comment; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_data_validity_comment ON activities USING btree (data_validity_comment);


--
-- Name: activities_data_validity_comment_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_data_validity_comment_like ON activities USING btree (data_validity_comment varchar_pattern_ops);


--
-- Name: activities_doc_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_doc_id ON activities USING btree (doc_id);


--
-- Name: activities_molregno; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_molregno ON activities USING btree (molregno);


--
-- Name: activities_pchembl_value; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_pchembl_value ON activities USING btree (pchembl_value);


--
-- Name: activities_published_relation; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_published_relation ON activities USING btree (published_relation);


--
-- Name: activities_published_relation_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_published_relation_like ON activities USING btree (published_relation varchar_pattern_ops);


--
-- Name: activities_published_type; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_published_type ON activities USING btree (published_type);


--
-- Name: activities_published_type_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_published_type_like ON activities USING btree (published_type varchar_pattern_ops);


--
-- Name: activities_published_units; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_published_units ON activities USING btree (published_units);


--
-- Name: activities_published_units_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_published_units_like ON activities USING btree (published_units varchar_pattern_ops);


--
-- Name: activities_published_value; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_published_value ON activities USING btree (published_value);


--
-- Name: activities_record_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_record_id ON activities USING btree (record_id);


--
-- Name: activities_standard_relation; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_standard_relation ON activities USING btree (standard_relation);


--
-- Name: activities_standard_relation_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_standard_relation_like ON activities USING btree (standard_relation varchar_pattern_ops);


--
-- Name: activities_standard_type; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_standard_type ON activities USING btree (standard_type);


--
-- Name: activities_standard_type_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_standard_type_like ON activities USING btree (standard_type varchar_pattern_ops);


--
-- Name: activities_standard_units; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_standard_units ON activities USING btree (standard_units);


--
-- Name: activities_standard_units_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_standard_units_like ON activities USING btree (standard_units varchar_pattern_ops);


--
-- Name: activities_standard_value; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX activities_standard_value ON activities USING btree (standard_value);


--
-- Name: assays_assay_type; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_assay_type ON assays USING btree (assay_type);


--
-- Name: assays_assay_type_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_assay_type_like ON assays USING btree (assay_type varchar_pattern_ops);


--
-- Name: assays_bao_format; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_bao_format ON assays USING btree (bao_format);


--
-- Name: assays_bao_format_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_bao_format_like ON assays USING btree (bao_format varchar_pattern_ops);


--
-- Name: assays_cell_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_cell_id ON assays USING btree (cell_id);


--
-- Name: assays_chembl_id_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_chembl_id_like ON assays USING btree (chembl_id varchar_pattern_ops);


--
-- Name: assays_confidence_score; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_confidence_score ON assays USING btree (confidence_score);


--
-- Name: assays_curated_by; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_curated_by ON assays USING btree (curated_by);


--
-- Name: assays_curated_by_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_curated_by_like ON assays USING btree (curated_by varchar_pattern_ops);


--
-- Name: assays_doc_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_doc_id ON assays USING btree (doc_id);


--
-- Name: assays_relationship_type; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_relationship_type ON assays USING btree (relationship_type);


--
-- Name: assays_relationship_type_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_relationship_type_like ON assays USING btree (relationship_type varchar_pattern_ops);


--
-- Name: assays_src_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_src_id ON assays USING btree (src_id);


--
-- Name: assays_tid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assays_tid ON assays USING btree (tid);


--
-- Name: binding_sites_tid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX binding_sites_tid ON binding_sites USING btree (tid);


--
-- Name: compound_records_compound_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX compound_records_compound_key ON compound_records USING btree (compound_key);


--
-- Name: compound_records_compound_key_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX compound_records_compound_key_like ON compound_records USING btree (compound_key varchar_pattern_ops);


--
-- Name: compound_records_doc_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX compound_records_doc_id ON compound_records USING btree (doc_id);


--
-- Name: compound_records_molregno; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX compound_records_molregno ON compound_records USING btree (molregno);


--
-- Name: compound_records_src_compound_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX compound_records_src_compound_id ON compound_records USING btree (src_compound_id);


--
-- Name: compound_records_src_compound_id_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX compound_records_src_compound_id_like ON compound_records USING btree (src_compound_id varchar_pattern_ops);


--
-- Name: compound_records_src_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX compound_records_src_id ON compound_records USING btree (src_id);


--
-- Name: compound_structures_standard_inchi_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX compound_structures_standard_inchi_key ON compound_structures USING btree (standard_inchi_key);


--
-- Name: compound_structures_standard_inchi_key_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX compound_structures_standard_inchi_key_like ON compound_structures USING btree (standard_inchi_key varchar_pattern_ops);


--
-- Name: docs_chembl_id_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX docs_chembl_id_like ON docs USING btree (chembl_id varchar_pattern_ops);


--
-- Name: docs_issue; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX docs_issue ON docs USING btree (issue);


--
-- Name: docs_issue_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX docs_issue_like ON docs USING btree (issue varchar_pattern_ops);


--
-- Name: docs_journal; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX docs_journal ON docs USING btree (journal);


--
-- Name: docs_journal_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX docs_journal_like ON docs USING btree (journal varchar_pattern_ops);


--
-- Name: docs_volume; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX docs_volume ON docs USING btree (volume);


--
-- Name: docs_volume_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX docs_volume_like ON docs USING btree (volume varchar_pattern_ops);


--
-- Name: docs_year; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX docs_year ON docs USING btree (year);


--
-- Name: molecule_dictionary_chembl_id_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX molecule_dictionary_chembl_id_like ON molecule_dictionary USING btree (chembl_id varchar_pattern_ops);


--
-- Name: molecule_dictionary_max_phase; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX molecule_dictionary_max_phase ON molecule_dictionary USING btree (max_phase);


--
-- Name: molecule_dictionary_pref_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX molecule_dictionary_pref_name ON molecule_dictionary USING btree (pref_name);


--
-- Name: molecule_dictionary_pref_name_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX molecule_dictionary_pref_name_like ON molecule_dictionary USING btree (pref_name varchar_pattern_ops);


--
-- Name: molecule_dictionary_therapeutic_flag; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX molecule_dictionary_therapeutic_flag ON molecule_dictionary USING btree (therapeutic_flag);


--
-- Name: predicted_binding_domains_activity_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX predicted_binding_domains_activity_id ON predicted_binding_domains USING btree (activity_id);


--
-- Name: predicted_binding_domains_site_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX predicted_binding_domains_site_id ON predicted_binding_domains USING btree (site_id);


--
-- Name: site_components_component_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX site_components_component_id ON site_components USING btree (component_id);


--
-- Name: site_components_domain_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX site_components_domain_id ON site_components USING btree (domain_id);


--
-- Name: site_components_site_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX site_components_site_id ON site_components USING btree (site_id);


--
-- Name: activities_assay_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_assay_id_fkey FOREIGN KEY (assay_id) REFERENCES assays(assay_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: activities_data_validity_comment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_data_validity_comment_fkey FOREIGN KEY (data_validity_comment) REFERENCES data_validity_lookup(data_validity_comment) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: activities_doc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES docs(doc_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: activities_molregno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_molregno_fkey FOREIGN KEY (molregno) REFERENCES molecule_dictionary(molregno) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: activities_record_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY activities
---    ADD CONSTRAINT activities_record_id_fkey FOREIGN KEY (record_id) REFERENCES compound_records(record_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: assays_assay_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY assays
---    ADD CONSTRAINT assays_assay_type_fkey FOREIGN KEY (assay_type) REFERENCES assay_type(assay_type) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: assays_cell_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY assays
---    ADD CONSTRAINT assays_cell_id_fkey FOREIGN KEY (cell_id) REFERENCES cell_dictionary(cell_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: assays_chembl_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY assays
---    ADD CONSTRAINT assays_chembl_id_fkey FOREIGN KEY (chembl_id) REFERENCES chembl_id_lookup(chembl_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: assays_confidence_score_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY assays
---    ADD CONSTRAINT assays_confidence_score_fkey FOREIGN KEY (confidence_score) REFERENCES confidence_score_lookup(confidence_score) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: assays_curated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY assays
---    ADD CONSTRAINT assays_curated_by_fkey FOREIGN KEY (curated_by) REFERENCES curation_lookup(curated_by) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: assays_doc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY assays
---    ADD CONSTRAINT assays_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES docs(doc_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: assays_relationship_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY assays
---    ADD CONSTRAINT assays_relationship_type_fkey FOREIGN KEY (relationship_type) REFERENCES relationship_type(relationship_type) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: assays_src_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY assays
---    ADD CONSTRAINT assays_src_id_fkey FOREIGN KEY (src_id) REFERENCES source(src_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: assays_tid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY assays
---    ADD CONSTRAINT assays_tid_fkey FOREIGN KEY (tid) REFERENCES target_dictionary(tid) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: binding_sites_tid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY binding_sites
---    ADD CONSTRAINT binding_sites_tid_fkey FOREIGN KEY (tid) REFERENCES target_dictionary(tid) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: compound_records_doc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY compound_records
---    ADD CONSTRAINT compound_records_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES docs(doc_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: compound_records_molregno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY compound_records
---    ADD CONSTRAINT compound_records_molregno_fkey FOREIGN KEY (molregno) REFERENCES molecule_dictionary(molregno) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: compound_records_src_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY compound_records
---    ADD CONSTRAINT compound_records_src_id_fkey FOREIGN KEY (src_id) REFERENCES source(src_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: compound_structures_molregno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY compound_structures
---    ADD CONSTRAINT compound_structures_molregno_fkey FOREIGN KEY (molregno) REFERENCES molecule_dictionary(molregno) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: molecule_dictionary_chembl_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY molecule_dictionary
---    ADD CONSTRAINT molecule_dictionary_chembl_id_fkey FOREIGN KEY (chembl_id) REFERENCES chembl_id_lookup(chembl_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: predicted_binding_domains_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY predicted_binding_domains
---    ADD CONSTRAINT predicted_binding_domains_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(activity_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: predicted_binding_domains_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY predicted_binding_domains
---    ADD CONSTRAINT predicted_binding_domains_site_id_fkey FOREIGN KEY (site_id) REFERENCES binding_sites(site_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_components_component_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY site_components
---    ADD CONSTRAINT site_components_component_id_fkey FOREIGN KEY (component_id) REFERENCES component_sequences(component_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_components_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY site_components
---    ADD CONSTRAINT site_components_domain_id_fkey FOREIGN KEY (domain_id) REFERENCES domains(domain_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_components_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

---ALTER TABLE ONLY site_components
---    ADD CONSTRAINT site_components_site_id_fkey FOREIGN KEY (site_id) REFERENCES binding_sites(site_id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

