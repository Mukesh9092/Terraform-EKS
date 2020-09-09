
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TYPE gql_type AS ENUM (
  'Category',
  'ClientApp',
  'CodedConcept',
  'ContactPoint',
  'DataQualityMetric',
  'DataQualityMetricRole',
  'DataQualityValue',
  'DeliveryStream',
  'Device',
  'DeviceModel',
  'DeviceModelRole',
  'DeviceRole',
  'FunctionalExpression',
  'FunctionalExpressionRole',
  'Identifier',
  'Image',
  'ImageRole',
  'Library',
  'Location',
  'LocationEvent',
  'LocationRole',
  'Organization',
  'OrganizationRole',
  'Person',
  'PersonRole',
  'PostalAddress',
  'PostalAddressComponent',
  'SensorStudy',
  'SensorSubject',
  'SensorSubjectRole',
  'Tag',
  'Token',
  'TrackingEvent',
  'Vocabulary'
);


CREATE TABLE IF NOT EXISTS entities (
  id UUID PRIMARY KEY, -- v1 uuid
  id64 CHAR(22) UNIQUE NOT NULL, -- npmjs.com/package/id64
  type_name gql_type NOT NULL,
  ctime TIMESTAMP WITH TIME ZONE NOT NULL,
  mtime TIMESTAMP WITH TIME ZONE NOT NULL,
  deleted BOOLEAN NOT NULL DEFAULT FALSE
);


CREATE TYPE AuditRecordType AS ENUM (
  'CREATED',
  'DELETED',
  'UPDATED'
);


CREATE TABLE IF NOT EXISTS categories (
  id                                             UUID PRIMARY KEY REFERENCES entities,
  name                                           VARCHAR(255),
  description                                    VARCHAR(255),
  url                                            VARCHAR UNIQUE,
  ico_categories_client_app_id                   UUID,
  ico_categories_contact_point_id                UUID,
  ico_categories_data_quality_metric_id          UUID,
  ico_categories_data_quality_metric_role_id     UUID,
  ico_categories_data_quality_value_id           UUID,
  ico_categories_delivery_stream_id              UUID,
  ico_categories_device_id                       UUID,
  ico_categories_device_model_id                 UUID,
  ico_properties_device_model_id                 UUID,
  ico_categories_device_model_role_id            UUID,
  ico_categories_device_role_id                  UUID,
  ico_categories_functional_expression_id        UUID,
  ico_categories_functional_expression_role_id   UUID,
  ico_categories_identifier_id                   UUID,
  ico_categories_image_id                        UUID,
  ico_categories_image_role_id                   UUID,
  ico_categories_library_id                      UUID,
  ico_categories_location_id                     UUID,
  ico_categories_location_event_id               UUID,
  ico_categories_location_role_id                UUID,
  ico_categories_organization_id                 UUID,
  ico_categories_organization_role_id            UUID,
  ico_categories_person_id                       UUID,
  ico_categories_person_role_id                  UUID,
  ico_categories_postal_address_id               UUID,
  ico_categories_postal_address_component_id     UUID,
  ico_categories_sensor_study_id                 UUID,
  ico_secondary_indications_sensor_study_id      UUID,
  ico_categories_sensor_subject_id               UUID,
  ico_categories_sensor_subject_role_id          UUID,
  ico_categories_tag_id                          UUID,
  ico_categories_token_id                        UUID,
  ico_categories_tracking_event_id               UUID,
  ico_categories_vocabulary_id                   UUID,
  during_start                                   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                                     TIMESTAMP WITH TIME ZONE,
  item_number                                    INT,
  classification_id                              UUID NOT NULL,
  audit_type                                     AuditRecordType NOT NULL,
  audit_mtime                                    TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                          VARCHAR NOT NULL,
  audit_reason_text                              VARCHAR(255) NOT NULL,
  audit_user_id                                  VARCHAR(255) NOT NULL,
  audit_app_id                                   VARCHAR(255) NOT NULL,
  audit_details                                  JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS client_apps (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255) NOT NULL,
  description             VARCHAR(255) NOT NULL,
  url                     VARCHAR NOT NULL UNIQUE,
  type_id                 UUID,
  privacy_url             VARCHAR NOT NULL,
  owner_id                UUID NOT NULL,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS coded_concepts (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255) NOT NULL,
  description             VARCHAR(255),
  url                     VARCHAR NOT NULL UNIQUE,
  curie                   VARCHAR NOT NULL UNIQUE,
  vocabulary_id           UUID NOT NULL,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS contact_points (
  id                                   UUID PRIMARY KEY REFERENCES entities,
  name                                 VARCHAR(255),
  description                          VARCHAR(255),
  url                                  VARCHAR UNIQUE,
  ico_contact_points_client_app_id     UUID,
  ico_contact_points_organization_id   UUID,
  ico_contact_points_person_id         UUID,
  during_start                         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                           TIMESTAMP WITH TIME ZONE,
  item_number                          INT,
  type_id                              UUID NOT NULL,
  value                                VARCHAR(255) NOT NULL,
  is_primary                           BOOLEAN NOT NULL,
  audit_type                           AuditRecordType NOT NULL,
  audit_mtime                          TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                VARCHAR NOT NULL,
  audit_reason_text                    VARCHAR(255) NOT NULL,
  audit_user_id                        VARCHAR(255) NOT NULL,
  audit_app_id                         VARCHAR(255) NOT NULL,
  audit_details                        JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS data_quality_metrics (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255) NOT NULL,
  description             VARCHAR(255) NOT NULL,
  url                     VARCHAR UNIQUE,
  type_id                 UUID NOT NULL,
  library_id              UUID,
  version                 VARCHAR(255),
  unit_id                 UUID NOT NULL,
  topic                   VARCHAR(255),
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS data_quality_metric_roles (
  id                                         UUID PRIMARY KEY REFERENCES entities,
  name                                       VARCHAR(255),
  description                                VARCHAR(255),
  url                                        VARCHAR UNIQUE,
  data_quality_metric_id                     UUID NOT NULL,
  ico_data_quality_metrics_sensor_study_id   UUID,
  during_start                               TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                                 TIMESTAMP WITH TIME ZONE,
  item_number                                INT,
  type_id                                    UUID,
  audit_type                                 AuditRecordType NOT NULL,
  audit_mtime                                TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                      VARCHAR NOT NULL,
  audit_reason_text                          VARCHAR(255) NOT NULL,
  audit_user_id                              VARCHAR(255) NOT NULL,
  audit_app_id                               VARCHAR(255) NOT NULL,
  audit_details                              JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS data_quality_values (
  id                                                    UUID PRIMARY KEY REFERENCES entities,
  name                                                  VARCHAR(255),
  description                                           VARCHAR(255),
  url                                                   VARCHAR UNIQUE,
  ico_data_quality_values_contact_point_id              UUID,
  ico_data_quality_values_delivery_stream_id            UUID,
  ico_data_quality_values_device_id                     UUID,
  ico_data_quality_values_device_model_id               UUID,
  ico_data_quality_values_identifier_id                 UUID,
  ico_data_quality_values_image_id                      UUID,
  ico_data_quality_values_library_id                    UUID,
  ico_data_quality_values_location_id                   UUID,
  ico_data_quality_values_organization_id               UUID,
  ico_data_quality_values_person_id                     UUID,
  ico_data_quality_values_postal_address_id             UUID,
  ico_data_quality_values_postal_address_component_id   UUID,
  ico_data_quality_values_sensor_study_id               UUID,
  ico_data_quality_values_sensor_subject_id             UUID,
  during_start                                          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                                            TIMESTAMP WITH TIME ZONE,
  item_number                                           INT,
  type_id                                               UUID,
  metric_id                                             UUID NOT NULL,
  result_amount                                         DOUBLE PRECISION NOT NULL,
  result_unit                                           VARCHAR NOT NULL,
  audit_type                                            AuditRecordType NOT NULL,
  audit_mtime                                           TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                                 VARCHAR NOT NULL,
  audit_reason_text                                     VARCHAR(255) NOT NULL,
  audit_user_id                                         VARCHAR(255) NOT NULL,
  audit_app_id                                          VARCHAR(255) NOT NULL,
  audit_details                                         JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS delivery_streams (
  id                                     UUID PRIMARY KEY REFERENCES entities,
  name                                   VARCHAR(255) NOT NULL,
  description                            VARCHAR(255),
  url                                    VARCHAR NOT NULL,
  ico_delivery_streams_sensor_study_id   UUID,
  during_start                           TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                             TIMESTAMP WITH TIME ZONE,
  item_number                            INT,
  type_id                                UUID,
  batch_mime_type                        VARCHAR(255),
  max_batch_size                         INT,
  max_batch_time                         VARCHAR(30),
  audit_type                             AuditRecordType NOT NULL,
  audit_mtime                            TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                  VARCHAR NOT NULL,
  audit_reason_text                      VARCHAR(255) NOT NULL,
  audit_user_id                          VARCHAR(255) NOT NULL,
  audit_app_id                           VARCHAR(255) NOT NULL,
  audit_details                          JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS devices (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255),
  description             VARCHAR(255),
  url                     VARCHAR UNIQUE,
  type_id                 UUID NOT NULL,
  model_id                UUID NOT NULL,
  manufacture_date        TIMESTAMP WITH TIME ZONE,
  expiration_date         TIMESTAMP WITH TIME ZONE,
  lot_number              VARCHAR(255),
  serial_number           VARCHAR(255),
  is_complete_kit         BOOLEAN NOT NULL,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS device_models (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255),
  description             VARCHAR(255),
  url                     VARCHAR UNIQUE,
  type_id                 UUID NOT NULL,
  manufacturer_id         UUID NOT NULL,
  brand                   VARCHAR(255),
  model_number            VARCHAR(255) NOT NULL,
  is_sensor               BOOLEAN,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS device_model_roles (
  id                               UUID PRIMARY KEY REFERENCES entities,
  name                             VARCHAR(255),
  description                      VARCHAR(255),
  url                              VARCHAR UNIQUE,
  device_model_id                  UUID NOT NULL,
  ico_is_part_of_device_model_id   UUID,
  ico_has_parts_device_model_id    UUID,
  during_start                     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                       TIMESTAMP WITH TIME ZONE,
  item_number                      INT,
  type_id                          UUID,
  audit_type                       AuditRecordType NOT NULL,
  audit_mtime                      TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language            VARCHAR NOT NULL,
  audit_reason_text                VARCHAR(255) NOT NULL,
  audit_user_id                    VARCHAR(255) NOT NULL,
  audit_app_id                     VARCHAR(255) NOT NULL,
  audit_details                    JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS device_roles (
  id                              UUID PRIMARY KEY REFERENCES entities,
  name                            VARCHAR(255),
  description                     VARCHAR(255),
  url                             VARCHAR UNIQUE,
  device_id                       UUID NOT NULL,
  ico_is_part_of_device_id        UUID,
  ico_has_parts_device_id         UUID,
  ico_devices_organization_id     UUID,
  ico_devices_sensor_subject_id   UUID,
  during_start                    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                      TIMESTAMP WITH TIME ZONE,
  item_number                     INT,
  type_id                         UUID,
  audit_type                      AuditRecordType NOT NULL,
  audit_mtime                     TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language           VARCHAR NOT NULL,
  audit_reason_text               VARCHAR(255) NOT NULL,
  audit_user_id                   VARCHAR(255) NOT NULL,
  audit_app_id                    VARCHAR(255) NOT NULL,
  audit_details                   JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS functional_expressions (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255),
  description             VARCHAR(255),
  url                     VARCHAR UNIQUE,
  type_id                 UUID NOT NULL,
  library_id              UUID,
  version                 VARCHAR(255) NOT NULL,
  language_id             UUID NOT NULL,
  evaluator_id            UUID NOT NULL,
  target_id               UUID NOT NULL,
  expression              VARCHAR(255) NOT NULL,
  return_type_id          UUID NOT NULL,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS functional_expression_roles (
  id                                       UUID PRIMARY KEY REFERENCES entities,
  name                                     VARCHAR(255),
  description                              VARCHAR(255),
  url                                      VARCHAR UNIQUE,
  functional_expression_id                 UUID NOT NULL,
  ico_expressions_data_quality_metric_id   UUID,
  during_start                             TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                               TIMESTAMP WITH TIME ZONE,
  item_number                              INT,
  type_id                                  UUID,
  audit_type                               AuditRecordType NOT NULL,
  audit_mtime                              TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                    VARCHAR NOT NULL,
  audit_reason_text                        VARCHAR(255) NOT NULL,
  audit_user_id                            VARCHAR(255) NOT NULL,
  audit_app_id                             VARCHAR(255) NOT NULL,
  audit_details                            JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS identifiers (
  id                                   UUID PRIMARY KEY REFERENCES entities,
  name                                 VARCHAR(255),
  description                          VARCHAR(255),
  url                                  VARCHAR UNIQUE,
  ico_identifiers_client_app_id        UUID,
  ico_identifiers_delivery_stream_id   UUID,
  ico_identifiers_device_id            UUID,
  ico_identifiers_device_model_id      UUID,
  ico_identifiers_organization_id      UUID,
  ico_identifiers_person_id            UUID,
  ico_identifiers_sensor_study_id      UUID,
  ico_identifiers_sensor_subject_id    UUID,
  ico_identifiers_vocabulary_id        UUID,
  during_start                         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                           TIMESTAMP WITH TIME ZONE,
  item_number                          INT,
  type_id                              UUID,
  namespace                            VARCHAR NOT NULL,
  value                                VARCHAR(255) NOT NULL,
  is_private                           BOOLEAN,
  issuer_id                            UUID,
  algorithm_id                         UUID,
  jurisdiction_id                      UUID,
  audit_type                           AuditRecordType NOT NULL,
  audit_mtime                          TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                VARCHAR NOT NULL,
  audit_reason_text                    VARCHAR(255) NOT NULL,
  audit_user_id                        VARCHAR(255) NOT NULL,
  audit_app_id                         VARCHAR(255) NOT NULL,
  audit_details                        JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS images (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255),
  description             VARCHAR(255),
  url                     VARCHAR NOT NULL,
  type_id                 UUID,
  mime_type               VARCHAR(255),
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS image_roles (
  id                           UUID PRIMARY KEY REFERENCES entities,
  name                         VARCHAR(255),
  description                  VARCHAR(255),
  url                          VARCHAR UNIQUE,
  image_id                     UUID NOT NULL,
  ico_images_client_app_id     UUID,
  ico_images_organization_id   UUID,
  ico_images_person_id         UUID,
  during_start                 TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                   TIMESTAMP WITH TIME ZONE,
  item_number                  INT,
  type_id                      UUID,
  audit_type                   AuditRecordType NOT NULL,
  audit_mtime                  TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language        VARCHAR NOT NULL,
  audit_reason_text            VARCHAR(255) NOT NULL,
  audit_user_id                VARCHAR(255) NOT NULL,
  audit_app_id                 VARCHAR(255) NOT NULL,
  audit_details                JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS libraries (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255) NOT NULL,
  description             VARCHAR(255) NOT NULL,
  url                     VARCHAR UNIQUE,
  type_id                 UUID,
  organization_id         UUID NOT NULL,
  study_id                UUID,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS locations (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255),
  description             VARCHAR(255),
  url                     VARCHAR UNIQUE,
  type_id                 UUID,
  locale_id               UUID,
  address_id              UUID,
  geo                     JSONB,
  utc_offset              INT,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS location_events (
  id                              UUID PRIMARY KEY REFERENCES entities,
  name                            VARCHAR(255),
  description                     VARCHAR(255),
  url                             VARCHAR UNIQUE,
  ico_location_events_device_id   UUID,
  during_start                    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                      TIMESTAMP WITH TIME ZONE,
  item_number                     INT,
  type_id                         UUID,
  location_id                     UUID NOT NULL,
  audit_type                      AuditRecordType NOT NULL,
  audit_mtime                     TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language           VARCHAR NOT NULL,
  audit_reason_text               VARCHAR(255) NOT NULL,
  audit_user_id                   VARCHAR(255) NOT NULL,
  audit_app_id                    VARCHAR(255) NOT NULL,
  audit_details                   JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS location_roles (
  id                              UUID PRIMARY KEY REFERENCES entities,
  name                            VARCHAR(255),
  description                     VARCHAR(255),
  url                             VARCHAR UNIQUE,
  location_id                     UUID NOT NULL,
  ico_locations_organization_id   UUID,
  ico_locations_person_id         UUID,
  during_start                    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                      TIMESTAMP WITH TIME ZONE,
  item_number                     INT,
  type_id                         UUID,
  audit_type                      AuditRecordType NOT NULL,
  audit_mtime                     TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language           VARCHAR NOT NULL,
  audit_reason_text               VARCHAR(255) NOT NULL,
  audit_user_id                   VARCHAR(255) NOT NULL,
  audit_app_id                    VARCHAR(255) NOT NULL,
  audit_details                   JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS organizations (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255),
  description             VARCHAR(255),
  url                     VARCHAR UNIQUE,
  type_id                 UUID,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS organization_roles (
  id                                       UUID PRIMARY KEY REFERENCES entities,
  name                                     VARCHAR(255),
  description                              VARCHAR(255),
  url                                      VARCHAR UNIQUE,
  organization_id                          UUID NOT NULL,
  ico_organizations_device_id              UUID,
  ico_super_organization_organization_id   UUID,
  ico_sub_organizations_organization_id    UUID,
  ico_organizations_sensor_study_id        UUID,
  during_start                             TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                               TIMESTAMP WITH TIME ZONE,
  item_number                              INT,
  type_id                                  UUID,
  audit_type                               AuditRecordType NOT NULL,
  audit_mtime                              TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                    VARCHAR NOT NULL,
  audit_reason_text                        VARCHAR(255) NOT NULL,
  audit_user_id                            VARCHAR(255) NOT NULL,
  audit_app_id                             VARCHAR(255) NOT NULL,
  audit_details                            JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS persons (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255) NOT NULL,
  description             VARCHAR(255),
  url                     VARCHAR UNIQUE,
  type_id                 UUID,
  nickname                VARCHAR(255),
  age                     INT,
  dob                     DATE,
  gender_id               UUID,
  height                  DOUBLE PRECISION,
  weight                  DOUBLE PRECISION,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS person_roles (
  id                            UUID PRIMARY KEY REFERENCES entities,
  name                          VARCHAR(255),
  description                   VARCHAR(255),
  url                           VARCHAR UNIQUE,
  person_id                     UUID NOT NULL,
  ico_members_organization_id   UUID,
  ico_persons_sensor_study_id   UUID,
  ico_user_tracking_event_id    UUID,
  during_start                  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                    TIMESTAMP WITH TIME ZONE,
  item_number                   INT,
  type_id                       UUID,
  audit_type                    AuditRecordType NOT NULL,
  audit_mtime                   TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language         VARCHAR NOT NULL,
  audit_reason_text             VARCHAR(255) NOT NULL,
  audit_user_id                 VARCHAR(255) NOT NULL,
  audit_app_id                  VARCHAR(255) NOT NULL,
  audit_details                 JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS postal_addresses (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255),
  description             VARCHAR(255),
  url                     VARCHAR UNIQUE,
  type_id                 UUID,
  text                    VARCHAR(255),
  country_id              UUID,
  locale_id               UUID,
  state_prov_id           UUID,
  locality                VARCHAR(255),
  postal_code             VARCHAR(255),
  street_1                VARCHAR(255),
  street_2                VARCHAR(255),
  geo                     JSONB,
  plus_code               VARCHAR(255),
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS postal_address_components (
  id                                 UUID PRIMARY KEY REFERENCES entities,
  name                               VARCHAR(255),
  description                        VARCHAR(255),
  url                                VARCHAR UNIQUE,
  ico_components_postal_address_id   UUID,
  during_start                       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                         TIMESTAMP WITH TIME ZONE,
  item_number                        INT,
  type_id                            UUID NOT NULL,
  value                              VARCHAR(255) NOT NULL,
  abbreviation                       VARCHAR(255),
  audit_type                         AuditRecordType NOT NULL,
  audit_mtime                        TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language              VARCHAR NOT NULL,
  audit_reason_text                  VARCHAR(255) NOT NULL,
  audit_user_id                      VARCHAR(255) NOT NULL,
  audit_app_id                       VARCHAR(255) NOT NULL,
  audit_details                      JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS sensor_studies (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255) NOT NULL,
  description             VARCHAR(255) NOT NULL,
  url                     VARCHAR UNIQUE,
  type_id                 UUID,
  protocol_id             VARCHAR(255) NOT NULL,
  phase_id                UUID NOT NULL,
  primary_indication_id   UUID NOT NULL,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS sensor_subjects (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255),
  description             VARCHAR(255),
  url                     VARCHAR UNIQUE,
  type_id                 UUID,
  person_id               UUID,
  study_id                UUID NOT NULL,
  site_id                 UUID,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS sensor_subject_roles (
  id                             UUID PRIMARY KEY REFERENCES entities,
  name                           VARCHAR(255),
  description                    VARCHAR(255),
  url                            VARCHAR UNIQUE,
  sensor_subject_id              UUID NOT NULL,
  ico_subjects_device_id         UUID,
  ico_subjects_sensor_study_id   UUID,
  during_start                   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                     TIMESTAMP WITH TIME ZONE,
  item_number                    INT,
  type_id                        UUID,
  audit_type                     AuditRecordType NOT NULL,
  audit_mtime                    TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language          VARCHAR NOT NULL,
  audit_reason_text              VARCHAR(255) NOT NULL,
  audit_user_id                  VARCHAR(255) NOT NULL,
  audit_app_id                   VARCHAR(255) NOT NULL,
  audit_details                  JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS tags (
  id                                       UUID PRIMARY KEY REFERENCES entities,
  name                                     VARCHAR(255) NOT NULL,
  description                              VARCHAR(255),
  url                                      VARCHAR UNIQUE,
  ico_tags_category_id                     UUID,
  ico_tags_client_app_id                   UUID,
  ico_tags_coded_concept_id                UUID,
  ico_tags_contact_point_id                UUID,
  ico_tags_data_quality_metric_id          UUID,
  ico_tags_data_quality_metric_role_id     UUID,
  ico_tags_data_quality_value_id           UUID,
  ico_tags_delivery_stream_id              UUID,
  ico_tags_device_id                       UUID,
  ico_tags_device_model_id                 UUID,
  ico_tags_device_model_role_id            UUID,
  ico_tags_device_role_id                  UUID,
  ico_tags_functional_expression_id        UUID,
  ico_tags_functional_expression_role_id   UUID,
  ico_tags_identifier_id                   UUID,
  ico_tags_image_id                        UUID,
  ico_tags_image_role_id                   UUID,
  ico_tags_library_id                      UUID,
  ico_tags_location_id                     UUID,
  ico_tags_location_event_id               UUID,
  ico_tags_location_role_id                UUID,
  ico_tags_organization_id                 UUID,
  ico_tags_organization_role_id            UUID,
  ico_tags_person_id                       UUID,
  ico_tags_person_role_id                  UUID,
  ico_tags_postal_address_id               UUID,
  ico_tags_postal_address_component_id     UUID,
  ico_tags_sensor_study_id                 UUID,
  ico_tags_sensor_subject_id               UUID,
  ico_tags_sensor_subject_role_id          UUID,
  ico_tags_token_id                        UUID,
  ico_tags_tracking_event_id               UUID,
  ico_tags_vocabulary_id                   UUID,
  during_start                             TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                               TIMESTAMP WITH TIME ZONE,
  item_number                              INT,
  type_id                                  UUID,
  value                                    JSONB NOT NULL,
  tag_is_sensitive                         BOOLEAN,
  audit_type                               AuditRecordType NOT NULL,
  audit_mtime                              TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                    VARCHAR NOT NULL,
  audit_reason_text                        VARCHAR(255) NOT NULL,
  audit_user_id                            VARCHAR(255) NOT NULL,
  audit_app_id                             VARCHAR(255) NOT NULL,
  audit_details                            JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS tokens (
  id                             UUID PRIMARY KEY REFERENCES entities,
  name                           VARCHAR(255),
  description                    VARCHAR(255),
  url                            VARCHAR UNIQUE,
  ico_tokens_organization_id     UUID,
  ico_tokens_person_id           UUID,
  ico_tokens_sensor_subject_id   UUID,
  during_start                   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                     TIMESTAMP WITH TIME ZONE,
  item_number                    INT,
  type_id                        UUID NOT NULL,
  issuer_id                      UUID NOT NULL,
  token                          VARCHAR(255) NOT NULL,
  audit_type                     AuditRecordType NOT NULL,
  audit_mtime                    TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language          VARCHAR NOT NULL,
  audit_reason_text              VARCHAR(255) NOT NULL,
  audit_user_id                  VARCHAR(255) NOT NULL,
  audit_app_id                   VARCHAR(255) NOT NULL,
  audit_details                  JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS tracking_events (
  id                                                  UUID PRIMARY KEY REFERENCES entities,
  name                                                VARCHAR(255),
  description                                         VARCHAR(255) NOT NULL,
  url                                                 VARCHAR UNIQUE,
  ico_tracking_events_client_app_id                   UUID,
  ico_tracking_events_coded_concept_id                UUID,
  ico_tracking_events_contact_point_id                UUID,
  ico_tracking_events_data_quality_metric_id          UUID,
  ico_tracking_events_data_quality_metric_role_id     UUID,
  ico_tracking_events_data_quality_value_id           UUID,
  ico_tracking_events_delivery_stream_id              UUID,
  ico_tracking_events_device_id                       UUID,
  ico_tracking_events_device_model_id                 UUID,
  ico_tracking_events_device_model_role_id            UUID,
  ico_tracking_events_device_role_id                  UUID,
  ico_tracking_events_functional_expression_id        UUID,
  ico_tracking_events_functional_expression_role_id   UUID,
  ico_tracking_events_identifier_id                   UUID,
  ico_tracking_events_image_id                        UUID,
  ico_tracking_events_image_role_id                   UUID,
  ico_tracking_events_library_id                      UUID,
  ico_tracking_events_location_id                     UUID,
  ico_tracking_events_location_event_id               UUID,
  ico_tracking_events_location_role_id                UUID,
  ico_tracking_events_organization_id                 UUID,
  ico_tracking_events_organization_role_id            UUID,
  ico_tracking_events_person_id                       UUID,
  ico_tracking_events_person_role_id                  UUID,
  ico_tracking_events_postal_address_id               UUID,
  ico_tracking_events_postal_address_component_id     UUID,
  ico_tracking_events_sensor_study_id                 UUID,
  ico_tracking_events_sensor_subject_id               UUID,
  ico_tracking_events_sensor_subject_role_id          UUID,
  ico_tracking_events_token_id                        UUID,
  ico_tracking_events_vocabulary_id                   UUID,
  during_start                                        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  during_end                                          TIMESTAMP WITH TIME ZONE,
  item_number                                         INT,
  type_id                                             UUID NOT NULL,
  client_app_id                                       UUID NOT NULL,
  user_id                                             UUID,
  audit_type                                          AuditRecordType NOT NULL,
  audit_mtime                                         TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language                               VARCHAR NOT NULL,
  audit_reason_text                                   VARCHAR(255) NOT NULL,
  audit_user_id                                       VARCHAR(255) NOT NULL,
  audit_app_id                                        VARCHAR(255) NOT NULL,
  audit_details                                       JSONB NOT NULL
);


CREATE TABLE IF NOT EXISTS vocabularies (
  id                      UUID PRIMARY KEY REFERENCES entities,
  name                    VARCHAR(255) NOT NULL,
  description             VARCHAR(255),
  url                     VARCHAR NOT NULL UNIQUE,
  type_id                 UUID,
  library_id              UUID,
  version                 VARCHAR(255),
  licence                 VARCHAR(255),
  copyright               VARCHAR(255),
  publisher_id            UUID,
  audit_type              AuditRecordType NOT NULL,
  audit_mtime             TIMESTAMP WITH TIME ZONE NOT NULL,
  audit_reason_language   VARCHAR NOT NULL,
  audit_reason_text       VARCHAR(255) NOT NULL,
  audit_user_id           VARCHAR(255) NOT NULL,
  audit_app_id            VARCHAR(255) NOT NULL,
  audit_details           JSONB NOT NULL
);


--
-- Add foreign keys
--

ALTER TABLE categories ADD FOREIGN KEY (ico_categories_client_app_id) REFERENCES client_apps DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_contact_point_id) REFERENCES contact_points DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_data_quality_metric_id) REFERENCES data_quality_metrics DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_data_quality_metric_role_id) REFERENCES data_quality_metric_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_data_quality_value_id) REFERENCES data_quality_values DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_delivery_stream_id) REFERENCES delivery_streams DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_device_model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_properties_device_model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_device_model_role_id) REFERENCES device_model_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_device_role_id) REFERENCES device_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_functional_expression_id) REFERENCES functional_expressions DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_functional_expression_role_id) REFERENCES functional_expression_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_identifier_id) REFERENCES identifiers DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_image_id) REFERENCES images DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_image_role_id) REFERENCES image_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_library_id) REFERENCES libraries DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_location_id) REFERENCES locations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_location_event_id) REFERENCES location_events DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_location_role_id) REFERENCES location_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_organization_role_id) REFERENCES organization_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_person_role_id) REFERENCES person_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_postal_address_id) REFERENCES postal_addresses DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_postal_address_component_id) REFERENCES postal_address_components DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_secondary_indications_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_sensor_subject_id) REFERENCES sensor_subjects DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_sensor_subject_role_id) REFERENCES sensor_subject_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_tag_id) REFERENCES tags DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_token_id) REFERENCES tokens DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_tracking_event_id) REFERENCES tracking_events DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (ico_categories_vocabulary_id) REFERENCES vocabularies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE categories ADD FOREIGN KEY (classification_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE client_apps ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE client_apps ADD FOREIGN KEY (owner_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE coded_concepts ADD FOREIGN KEY (vocabulary_id) REFERENCES vocabularies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE contact_points ADD FOREIGN KEY (ico_contact_points_client_app_id) REFERENCES client_apps DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE contact_points ADD FOREIGN KEY (ico_contact_points_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE contact_points ADD FOREIGN KEY (ico_contact_points_person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE contact_points ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_metrics ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_metrics ADD FOREIGN KEY (library_id) REFERENCES libraries DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_metrics ADD FOREIGN KEY (unit_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_metric_roles ADD FOREIGN KEY (data_quality_metric_id) REFERENCES data_quality_metrics DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_metric_roles ADD FOREIGN KEY (ico_data_quality_metrics_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_metric_roles ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_contact_point_id) REFERENCES contact_points DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_delivery_stream_id) REFERENCES delivery_streams DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_device_model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_identifier_id) REFERENCES identifiers DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_image_id) REFERENCES images DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_library_id) REFERENCES libraries DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_location_id) REFERENCES locations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_postal_address_id) REFERENCES postal_addresses DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_postal_address_component_id) REFERENCES postal_address_components DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (ico_data_quality_values_sensor_subject_id) REFERENCES sensor_subjects DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE data_quality_values ADD FOREIGN KEY (metric_id) REFERENCES data_quality_metrics DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE delivery_streams ADD FOREIGN KEY (ico_delivery_streams_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE delivery_streams ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE devices ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE devices ADD FOREIGN KEY (model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_models ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_models ADD FOREIGN KEY (manufacturer_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_model_roles ADD FOREIGN KEY (device_model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_model_roles ADD FOREIGN KEY (ico_is_part_of_device_model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_model_roles ADD FOREIGN KEY (ico_has_parts_device_model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_model_roles ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_roles ADD FOREIGN KEY (device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_roles ADD FOREIGN KEY (ico_is_part_of_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_roles ADD FOREIGN KEY (ico_has_parts_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_roles ADD FOREIGN KEY (ico_devices_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_roles ADD FOREIGN KEY (ico_devices_sensor_subject_id) REFERENCES sensor_subjects DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE device_roles ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE functional_expressions ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE functional_expressions ADD FOREIGN KEY (library_id) REFERENCES libraries DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE functional_expressions ADD FOREIGN KEY (language_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE functional_expressions ADD FOREIGN KEY (evaluator_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE functional_expressions ADD FOREIGN KEY (target_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE functional_expressions ADD FOREIGN KEY (return_type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE functional_expression_roles ADD FOREIGN KEY (functional_expression_id) REFERENCES functional_expressions DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE functional_expression_roles ADD FOREIGN KEY (ico_expressions_data_quality_metric_id) REFERENCES data_quality_metrics DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE functional_expression_roles ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (ico_identifiers_client_app_id) REFERENCES client_apps DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (ico_identifiers_delivery_stream_id) REFERENCES delivery_streams DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (ico_identifiers_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (ico_identifiers_device_model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (ico_identifiers_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (ico_identifiers_person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (ico_identifiers_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (ico_identifiers_sensor_subject_id) REFERENCES sensor_subjects DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (ico_identifiers_vocabulary_id) REFERENCES vocabularies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (issuer_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (algorithm_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE identifiers ADD FOREIGN KEY (jurisdiction_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE images ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE image_roles ADD FOREIGN KEY (image_id) REFERENCES images DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE image_roles ADD FOREIGN KEY (ico_images_client_app_id) REFERENCES client_apps DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE image_roles ADD FOREIGN KEY (ico_images_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE image_roles ADD FOREIGN KEY (ico_images_person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE image_roles ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE libraries ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE libraries ADD FOREIGN KEY (organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE libraries ADD FOREIGN KEY (study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE locations ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE locations ADD FOREIGN KEY (locale_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE locations ADD FOREIGN KEY (address_id) REFERENCES postal_addresses DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE location_events ADD FOREIGN KEY (ico_location_events_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE location_events ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE location_events ADD FOREIGN KEY (location_id) REFERENCES locations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE location_roles ADD FOREIGN KEY (location_id) REFERENCES locations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE location_roles ADD FOREIGN KEY (ico_locations_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE location_roles ADD FOREIGN KEY (ico_locations_person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE location_roles ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE organizations ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE organization_roles ADD FOREIGN KEY (organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE organization_roles ADD FOREIGN KEY (ico_organizations_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE organization_roles ADD FOREIGN KEY (ico_super_organization_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE organization_roles ADD FOREIGN KEY (ico_sub_organizations_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE organization_roles ADD FOREIGN KEY (ico_organizations_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE organization_roles ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE persons ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE persons ADD FOREIGN KEY (gender_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE person_roles ADD FOREIGN KEY (person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE person_roles ADD FOREIGN KEY (ico_members_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE person_roles ADD FOREIGN KEY (ico_persons_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE person_roles ADD FOREIGN KEY (ico_user_tracking_event_id) REFERENCES tracking_events DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE person_roles ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE postal_addresses ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE postal_addresses ADD FOREIGN KEY (country_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE postal_addresses ADD FOREIGN KEY (locale_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE postal_addresses ADD FOREIGN KEY (state_prov_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE postal_address_components ADD FOREIGN KEY (ico_components_postal_address_id) REFERENCES postal_addresses DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE postal_address_components ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_studies ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_studies ADD FOREIGN KEY (phase_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_studies ADD FOREIGN KEY (primary_indication_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_subjects ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_subjects ADD FOREIGN KEY (person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_subjects ADD FOREIGN KEY (study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_subjects ADD FOREIGN KEY (site_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_subject_roles ADD FOREIGN KEY (sensor_subject_id) REFERENCES sensor_subjects DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_subject_roles ADD FOREIGN KEY (ico_subjects_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_subject_roles ADD FOREIGN KEY (ico_subjects_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE sensor_subject_roles ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_category_id) REFERENCES categories DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_client_app_id) REFERENCES client_apps DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_coded_concept_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_contact_point_id) REFERENCES contact_points DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_data_quality_metric_id) REFERENCES data_quality_metrics DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_data_quality_metric_role_id) REFERENCES data_quality_metric_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_data_quality_value_id) REFERENCES data_quality_values DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_delivery_stream_id) REFERENCES delivery_streams DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_device_model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_device_model_role_id) REFERENCES device_model_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_device_role_id) REFERENCES device_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_functional_expression_id) REFERENCES functional_expressions DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_functional_expression_role_id) REFERENCES functional_expression_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_identifier_id) REFERENCES identifiers DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_image_id) REFERENCES images DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_image_role_id) REFERENCES image_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_library_id) REFERENCES libraries DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_location_id) REFERENCES locations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_location_event_id) REFERENCES location_events DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_location_role_id) REFERENCES location_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_organization_role_id) REFERENCES organization_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_person_role_id) REFERENCES person_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_postal_address_id) REFERENCES postal_addresses DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_postal_address_component_id) REFERENCES postal_address_components DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_sensor_subject_id) REFERENCES sensor_subjects DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_sensor_subject_role_id) REFERENCES sensor_subject_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_token_id) REFERENCES tokens DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_tracking_event_id) REFERENCES tracking_events DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (ico_tags_vocabulary_id) REFERENCES vocabularies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tags ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tokens ADD FOREIGN KEY (ico_tokens_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tokens ADD FOREIGN KEY (ico_tokens_person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tokens ADD FOREIGN KEY (ico_tokens_sensor_subject_id) REFERENCES sensor_subjects DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tokens ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tokens ADD FOREIGN KEY (issuer_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_client_app_id) REFERENCES client_apps DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_coded_concept_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_contact_point_id) REFERENCES contact_points DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_data_quality_metric_id) REFERENCES data_quality_metrics DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_data_quality_metric_role_id) REFERENCES data_quality_metric_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_data_quality_value_id) REFERENCES data_quality_values DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_delivery_stream_id) REFERENCES delivery_streams DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_device_id) REFERENCES devices DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_device_model_id) REFERENCES device_models DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_device_model_role_id) REFERENCES device_model_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_device_role_id) REFERENCES device_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_functional_expression_id) REFERENCES functional_expressions DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_functional_expression_role_id) REFERENCES functional_expression_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_identifier_id) REFERENCES identifiers DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_image_id) REFERENCES images DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_image_role_id) REFERENCES image_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_library_id) REFERENCES libraries DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_location_id) REFERENCES locations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_location_event_id) REFERENCES location_events DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_location_role_id) REFERENCES location_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_organization_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_organization_role_id) REFERENCES organization_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_person_id) REFERENCES persons DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_person_role_id) REFERENCES person_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_postal_address_id) REFERENCES postal_addresses DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_postal_address_component_id) REFERENCES postal_address_components DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_sensor_study_id) REFERENCES sensor_studies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_sensor_subject_id) REFERENCES sensor_subjects DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_sensor_subject_role_id) REFERENCES sensor_subject_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_token_id) REFERENCES tokens DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (ico_tracking_events_vocabulary_id) REFERENCES vocabularies DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (client_app_id) REFERENCES client_apps DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE tracking_events ADD FOREIGN KEY (user_id) REFERENCES person_roles DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE vocabularies ADD FOREIGN KEY (type_id) REFERENCES coded_concepts DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE vocabularies ADD FOREIGN KEY (library_id) REFERENCES libraries DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE vocabularies ADD FOREIGN KEY (publisher_id) REFERENCES organizations DEFERRABLE INITIALLY DEFERRED;

--
-- Add polymorphic constraints
--


-- For categories  
  
ALTER TABLE categories ADD CHECK((
      (ico_categories_client_app_id is not null)::integer +
      (ico_categories_contact_point_id is not null)::integer +
      (ico_categories_data_quality_metric_id is not null)::integer +
      (ico_categories_data_quality_metric_role_id is not null)::integer +
      (ico_categories_data_quality_value_id is not null)::integer +
      (ico_categories_delivery_stream_id is not null)::integer +
      (ico_categories_device_id is not null)::integer +
      (ico_categories_device_model_id is not null)::integer +
      (ico_properties_device_model_id is not null)::integer +
      (ico_categories_device_model_role_id is not null)::integer +
      (ico_categories_device_role_id is not null)::integer +
      (ico_categories_functional_expression_id is not null)::integer +
      (ico_categories_functional_expression_role_id is not null)::integer +
      (ico_categories_identifier_id is not null)::integer +
      (ico_categories_image_id is not null)::integer +
      (ico_categories_image_role_id is not null)::integer +
      (ico_categories_library_id is not null)::integer +
      (ico_categories_location_id is not null)::integer +
      (ico_categories_location_event_id is not null)::integer +
      (ico_categories_location_role_id is not null)::integer +
      (ico_categories_organization_id is not null)::integer +
      (ico_categories_organization_role_id is not null)::integer +
      (ico_categories_person_id is not null)::integer +
      (ico_categories_person_role_id is not null)::integer +
      (ico_categories_postal_address_id is not null)::integer +
      (ico_categories_postal_address_component_id is not null)::integer +
      (ico_categories_sensor_study_id is not null)::integer +
      (ico_secondary_indications_sensor_study_id is not null)::integer +
      (ico_categories_sensor_subject_id is not null)::integer +
      (ico_categories_sensor_subject_role_id is not null)::integer +
      (ico_categories_tag_id is not null)::integer +
      (ico_categories_token_id is not null)::integer +
      (ico_categories_tracking_event_id is not null)::integer +
      (ico_categories_vocabulary_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON categories (ico_categories_client_app_id, classification_id) where ico_categories_client_app_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_contact_point_id, classification_id) where ico_categories_contact_point_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_data_quality_metric_id, classification_id) where ico_categories_data_quality_metric_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_data_quality_metric_role_id, classification_id) where ico_categories_data_quality_metric_role_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_data_quality_value_id, classification_id) where ico_categories_data_quality_value_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_delivery_stream_id, classification_id) where ico_categories_delivery_stream_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_device_id, classification_id) where ico_categories_device_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_device_model_id, classification_id) where ico_categories_device_model_id is not null;
CREATE UNIQUE INDEX ON categories (ico_properties_device_model_id, classification_id) where ico_properties_device_model_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_device_model_role_id, classification_id) where ico_categories_device_model_role_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_device_role_id, classification_id) where ico_categories_device_role_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_functional_expression_id, classification_id) where ico_categories_functional_expression_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_functional_expression_role_id, classification_id) where ico_categories_functional_expression_role_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_identifier_id, classification_id) where ico_categories_identifier_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_image_id, classification_id) where ico_categories_image_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_image_role_id, classification_id) where ico_categories_image_role_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_library_id, classification_id) where ico_categories_library_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_location_id, classification_id) where ico_categories_location_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_location_event_id, classification_id) where ico_categories_location_event_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_location_role_id, classification_id) where ico_categories_location_role_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_organization_id, classification_id) where ico_categories_organization_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_organization_role_id, classification_id) where ico_categories_organization_role_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_person_id, classification_id) where ico_categories_person_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_person_role_id, classification_id) where ico_categories_person_role_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_postal_address_id, classification_id) where ico_categories_postal_address_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_postal_address_component_id, classification_id) where ico_categories_postal_address_component_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_sensor_study_id, classification_id) where ico_categories_sensor_study_id is not null;
CREATE UNIQUE INDEX ON categories (ico_secondary_indications_sensor_study_id, classification_id) where ico_secondary_indications_sensor_study_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_sensor_subject_id, classification_id) where ico_categories_sensor_subject_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_sensor_subject_role_id, classification_id) where ico_categories_sensor_subject_role_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_tag_id, classification_id) where ico_categories_tag_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_token_id, classification_id) where ico_categories_token_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_tracking_event_id, classification_id) where ico_categories_tracking_event_id is not null;
CREATE UNIQUE INDEX ON categories (ico_categories_vocabulary_id, classification_id) where ico_categories_vocabulary_id is not null;

-- For contact_points  
  
ALTER TABLE contact_points ADD CHECK((
      (ico_contact_points_client_app_id is not null)::integer +
      (ico_contact_points_organization_id is not null)::integer +
      (ico_contact_points_person_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON contact_points (ico_contact_points_client_app_id, value) where ico_contact_points_client_app_id is not null;
CREATE UNIQUE INDEX ON contact_points (ico_contact_points_organization_id, value) where ico_contact_points_organization_id is not null;
CREATE UNIQUE INDEX ON contact_points (ico_contact_points_person_id, value) where ico_contact_points_person_id is not null;

-- For data_quality_metric_roles  
  
ALTER TABLE data_quality_metric_roles ADD CHECK((
      (ico_data_quality_metrics_sensor_study_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON data_quality_metric_roles (ico_data_quality_metrics_sensor_study_id, data_quality_metric_id) where ico_data_quality_metrics_sensor_study_id is not null;

-- For data_quality_values  
  
ALTER TABLE data_quality_values ADD CHECK((
      (ico_data_quality_values_contact_point_id is not null)::integer +
      (ico_data_quality_values_delivery_stream_id is not null)::integer +
      (ico_data_quality_values_device_id is not null)::integer +
      (ico_data_quality_values_device_model_id is not null)::integer +
      (ico_data_quality_values_identifier_id is not null)::integer +
      (ico_data_quality_values_image_id is not null)::integer +
      (ico_data_quality_values_library_id is not null)::integer +
      (ico_data_quality_values_location_id is not null)::integer +
      (ico_data_quality_values_organization_id is not null)::integer +
      (ico_data_quality_values_person_id is not null)::integer +
      (ico_data_quality_values_postal_address_id is not null)::integer +
      (ico_data_quality_values_postal_address_component_id is not null)::integer +
      (ico_data_quality_values_sensor_study_id is not null)::integer +
      (ico_data_quality_values_sensor_subject_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_contact_point_id, metric_id) where ico_data_quality_values_contact_point_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_delivery_stream_id, metric_id) where ico_data_quality_values_delivery_stream_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_device_id, metric_id) where ico_data_quality_values_device_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_device_model_id, metric_id) where ico_data_quality_values_device_model_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_identifier_id, metric_id) where ico_data_quality_values_identifier_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_image_id, metric_id) where ico_data_quality_values_image_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_library_id, metric_id) where ico_data_quality_values_library_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_location_id, metric_id) where ico_data_quality_values_location_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_organization_id, metric_id) where ico_data_quality_values_organization_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_person_id, metric_id) where ico_data_quality_values_person_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_postal_address_id, metric_id) where ico_data_quality_values_postal_address_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_postal_address_component_id, metric_id) where ico_data_quality_values_postal_address_component_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_sensor_study_id, metric_id) where ico_data_quality_values_sensor_study_id is not null;
CREATE UNIQUE INDEX ON data_quality_values (ico_data_quality_values_sensor_subject_id, metric_id) where ico_data_quality_values_sensor_subject_id is not null;

-- For delivery_streams  
  
ALTER TABLE delivery_streams ADD CHECK((
      (ico_delivery_streams_sensor_study_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON delivery_streams (ico_delivery_streams_sensor_study_id, url) where ico_delivery_streams_sensor_study_id is not null;

-- For device_model_roles  
  
ALTER TABLE device_model_roles ADD CHECK((
      (ico_is_part_of_device_model_id is not null)::integer +
      (ico_has_parts_device_model_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON device_model_roles (ico_is_part_of_device_model_id, id) where ico_is_part_of_device_model_id is not null;
CREATE UNIQUE INDEX ON device_model_roles (ico_has_parts_device_model_id, device_model_id) where ico_has_parts_device_model_id is not null;

-- For device_roles  
  
ALTER TABLE device_roles ADD CHECK((
      (ico_is_part_of_device_id is not null)::integer +
      (ico_has_parts_device_id is not null)::integer +
      (ico_devices_organization_id is not null)::integer +
      (ico_devices_sensor_subject_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON device_roles (ico_is_part_of_device_id, id) where ico_is_part_of_device_id is not null;
CREATE UNIQUE INDEX ON device_roles (ico_has_parts_device_id, device_id) where ico_has_parts_device_id is not null;
CREATE UNIQUE INDEX ON device_roles (ico_devices_organization_id, device_id) where ico_devices_organization_id is not null;
CREATE UNIQUE INDEX ON device_roles (ico_devices_sensor_subject_id, device_id) where ico_devices_sensor_subject_id is not null;

-- For functional_expression_roles  
  
ALTER TABLE functional_expression_roles ADD CHECK((
      (ico_expressions_data_quality_metric_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON functional_expression_roles (ico_expressions_data_quality_metric_id, functional_expression_id) where ico_expressions_data_quality_metric_id is not null;

-- For identifiers  
  
ALTER TABLE identifiers ADD CHECK((
      (ico_identifiers_client_app_id is not null)::integer +
      (ico_identifiers_delivery_stream_id is not null)::integer +
      (ico_identifiers_device_id is not null)::integer +
      (ico_identifiers_device_model_id is not null)::integer +
      (ico_identifiers_organization_id is not null)::integer +
      (ico_identifiers_person_id is not null)::integer +
      (ico_identifiers_sensor_study_id is not null)::integer +
      (ico_identifiers_sensor_subject_id is not null)::integer +
      (ico_identifiers_vocabulary_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON identifiers (ico_identifiers_client_app_id, value) where ico_identifiers_client_app_id is not null;
CREATE UNIQUE INDEX ON identifiers (ico_identifiers_delivery_stream_id, value) where ico_identifiers_delivery_stream_id is not null;
CREATE UNIQUE INDEX ON identifiers (ico_identifiers_device_id, value) where ico_identifiers_device_id is not null;
CREATE UNIQUE INDEX ON identifiers (ico_identifiers_device_model_id, value) where ico_identifiers_device_model_id is not null;
CREATE UNIQUE INDEX ON identifiers (ico_identifiers_organization_id, value) where ico_identifiers_organization_id is not null;
CREATE UNIQUE INDEX ON identifiers (ico_identifiers_person_id, value) where ico_identifiers_person_id is not null;
CREATE UNIQUE INDEX ON identifiers (ico_identifiers_sensor_study_id, value) where ico_identifiers_sensor_study_id is not null;
CREATE UNIQUE INDEX ON identifiers (ico_identifiers_sensor_subject_id, value) where ico_identifiers_sensor_subject_id is not null;
CREATE UNIQUE INDEX ON identifiers (ico_identifiers_vocabulary_id, value) where ico_identifiers_vocabulary_id is not null;

-- For image_roles  
  
ALTER TABLE image_roles ADD CHECK((
      (ico_images_client_app_id is not null)::integer +
      (ico_images_organization_id is not null)::integer +
      (ico_images_person_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON image_roles (ico_images_client_app_id, image_id) where ico_images_client_app_id is not null;
CREATE UNIQUE INDEX ON image_roles (ico_images_organization_id, image_id) where ico_images_organization_id is not null;
CREATE UNIQUE INDEX ON image_roles (ico_images_person_id, image_id) where ico_images_person_id is not null;

-- For location_events  
  
ALTER TABLE location_events ADD CHECK((
      (ico_location_events_device_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON location_events (ico_location_events_device_id, location_id, during_start) where ico_location_events_device_id is not null;

-- For location_roles  
  
ALTER TABLE location_roles ADD CHECK((
      (ico_locations_organization_id is not null)::integer +
      (ico_locations_person_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON location_roles (ico_locations_organization_id, location_id) where ico_locations_organization_id is not null;
CREATE UNIQUE INDEX ON location_roles (ico_locations_person_id, location_id) where ico_locations_person_id is not null;

-- For organization_roles  
  
ALTER TABLE organization_roles ADD CHECK((
      (ico_organizations_device_id is not null)::integer +
      (ico_super_organization_organization_id is not null)::integer +
      (ico_sub_organizations_organization_id is not null)::integer +
      (ico_organizations_sensor_study_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON organization_roles (ico_organizations_device_id, organization_id) where ico_organizations_device_id is not null;
CREATE UNIQUE INDEX ON organization_roles (ico_super_organization_organization_id, id) where ico_super_organization_organization_id is not null;
CREATE UNIQUE INDEX ON organization_roles (ico_sub_organizations_organization_id, organization_id) where ico_sub_organizations_organization_id is not null;
CREATE UNIQUE INDEX ON organization_roles (ico_organizations_sensor_study_id, organization_id) where ico_organizations_sensor_study_id is not null;

-- For person_roles  
  
ALTER TABLE person_roles ADD CHECK((
      (ico_members_organization_id is not null)::integer +
      (ico_persons_sensor_study_id is not null)::integer +
      (ico_user_tracking_event_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON person_roles (ico_members_organization_id, person_id) where ico_members_organization_id is not null;
CREATE UNIQUE INDEX ON person_roles (ico_persons_sensor_study_id, person_id) where ico_persons_sensor_study_id is not null;
CREATE UNIQUE INDEX ON person_roles (ico_user_tracking_event_id, id) where ico_user_tracking_event_id is not null;

-- For postal_address_components  
  
ALTER TABLE postal_address_components ADD CHECK((
      (ico_components_postal_address_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON postal_address_components (ico_components_postal_address_id, value) where ico_components_postal_address_id is not null;

-- For sensor_subject_roles  
  
ALTER TABLE sensor_subject_roles ADD CHECK((
      (ico_subjects_device_id is not null)::integer +
      (ico_subjects_sensor_study_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON sensor_subject_roles (ico_subjects_device_id, sensor_subject_id) where ico_subjects_device_id is not null;
CREATE UNIQUE INDEX ON sensor_subject_roles (ico_subjects_sensor_study_id, sensor_subject_id) where ico_subjects_sensor_study_id is not null;

-- For tags  
  
ALTER TABLE tags ADD CHECK((
      (ico_tags_category_id is not null)::integer +
      (ico_tags_client_app_id is not null)::integer +
      (ico_tags_coded_concept_id is not null)::integer +
      (ico_tags_contact_point_id is not null)::integer +
      (ico_tags_data_quality_metric_id is not null)::integer +
      (ico_tags_data_quality_metric_role_id is not null)::integer +
      (ico_tags_data_quality_value_id is not null)::integer +
      (ico_tags_delivery_stream_id is not null)::integer +
      (ico_tags_device_id is not null)::integer +
      (ico_tags_device_model_id is not null)::integer +
      (ico_tags_device_model_role_id is not null)::integer +
      (ico_tags_device_role_id is not null)::integer +
      (ico_tags_functional_expression_id is not null)::integer +
      (ico_tags_functional_expression_role_id is not null)::integer +
      (ico_tags_identifier_id is not null)::integer +
      (ico_tags_image_id is not null)::integer +
      (ico_tags_image_role_id is not null)::integer +
      (ico_tags_library_id is not null)::integer +
      (ico_tags_location_id is not null)::integer +
      (ico_tags_location_event_id is not null)::integer +
      (ico_tags_location_role_id is not null)::integer +
      (ico_tags_organization_id is not null)::integer +
      (ico_tags_organization_role_id is not null)::integer +
      (ico_tags_person_id is not null)::integer +
      (ico_tags_person_role_id is not null)::integer +
      (ico_tags_postal_address_id is not null)::integer +
      (ico_tags_postal_address_component_id is not null)::integer +
      (ico_tags_sensor_study_id is not null)::integer +
      (ico_tags_sensor_subject_id is not null)::integer +
      (ico_tags_sensor_subject_role_id is not null)::integer +
      (ico_tags_token_id is not null)::integer +
      (ico_tags_tracking_event_id is not null)::integer +
      (ico_tags_vocabulary_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON tags (ico_tags_category_id, name) where ico_tags_category_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_client_app_id, name) where ico_tags_client_app_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_coded_concept_id, name) where ico_tags_coded_concept_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_contact_point_id, name) where ico_tags_contact_point_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_data_quality_metric_id, name) where ico_tags_data_quality_metric_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_data_quality_metric_role_id, name) where ico_tags_data_quality_metric_role_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_data_quality_value_id, name) where ico_tags_data_quality_value_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_delivery_stream_id, name) where ico_tags_delivery_stream_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_device_id, name) where ico_tags_device_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_device_model_id, name) where ico_tags_device_model_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_device_model_role_id, name) where ico_tags_device_model_role_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_device_role_id, name) where ico_tags_device_role_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_functional_expression_id, name) where ico_tags_functional_expression_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_functional_expression_role_id, name) where ico_tags_functional_expression_role_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_identifier_id, name) where ico_tags_identifier_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_image_id, name) where ico_tags_image_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_image_role_id, name) where ico_tags_image_role_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_library_id, name) where ico_tags_library_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_location_id, name) where ico_tags_location_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_location_event_id, name) where ico_tags_location_event_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_location_role_id, name) where ico_tags_location_role_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_organization_id, name) where ico_tags_organization_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_organization_role_id, name) where ico_tags_organization_role_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_person_id, name) where ico_tags_person_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_person_role_id, name) where ico_tags_person_role_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_postal_address_id, name) where ico_tags_postal_address_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_postal_address_component_id, name) where ico_tags_postal_address_component_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_sensor_study_id, name) where ico_tags_sensor_study_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_sensor_subject_id, name) where ico_tags_sensor_subject_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_sensor_subject_role_id, name) where ico_tags_sensor_subject_role_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_token_id, name) where ico_tags_token_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_tracking_event_id, name) where ico_tags_tracking_event_id is not null;
CREATE UNIQUE INDEX ON tags (ico_tags_vocabulary_id, name) where ico_tags_vocabulary_id is not null;

-- For tokens  
  
ALTER TABLE tokens ADD CHECK((
      (ico_tokens_organization_id is not null)::integer +
      (ico_tokens_person_id is not null)::integer +
      (ico_tokens_sensor_subject_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON tokens (ico_tokens_organization_id, token) where ico_tokens_organization_id is not null;
CREATE UNIQUE INDEX ON tokens (ico_tokens_person_id, token) where ico_tokens_person_id is not null;
CREATE UNIQUE INDEX ON tokens (ico_tokens_sensor_subject_id, token) where ico_tokens_sensor_subject_id is not null;

-- For tracking_events  
  
ALTER TABLE tracking_events ADD CHECK((
      (ico_tracking_events_client_app_id is not null)::integer +
      (ico_tracking_events_coded_concept_id is not null)::integer +
      (ico_tracking_events_contact_point_id is not null)::integer +
      (ico_tracking_events_data_quality_metric_id is not null)::integer +
      (ico_tracking_events_data_quality_metric_role_id is not null)::integer +
      (ico_tracking_events_data_quality_value_id is not null)::integer +
      (ico_tracking_events_delivery_stream_id is not null)::integer +
      (ico_tracking_events_device_id is not null)::integer +
      (ico_tracking_events_device_model_id is not null)::integer +
      (ico_tracking_events_device_model_role_id is not null)::integer +
      (ico_tracking_events_device_role_id is not null)::integer +
      (ico_tracking_events_functional_expression_id is not null)::integer +
      (ico_tracking_events_functional_expression_role_id is not null)::integer +
      (ico_tracking_events_identifier_id is not null)::integer +
      (ico_tracking_events_image_id is not null)::integer +
      (ico_tracking_events_image_role_id is not null)::integer +
      (ico_tracking_events_library_id is not null)::integer +
      (ico_tracking_events_location_id is not null)::integer +
      (ico_tracking_events_location_event_id is not null)::integer +
      (ico_tracking_events_location_role_id is not null)::integer +
      (ico_tracking_events_organization_id is not null)::integer +
      (ico_tracking_events_organization_role_id is not null)::integer +
      (ico_tracking_events_person_id is not null)::integer +
      (ico_tracking_events_person_role_id is not null)::integer +
      (ico_tracking_events_postal_address_id is not null)::integer +
      (ico_tracking_events_postal_address_component_id is not null)::integer +
      (ico_tracking_events_sensor_study_id is not null)::integer +
      (ico_tracking_events_sensor_subject_id is not null)::integer +
      (ico_tracking_events_sensor_subject_role_id is not null)::integer +
      (ico_tracking_events_token_id is not null)::integer +
      (ico_tracking_events_vocabulary_id is not null)::integer
    ) = 1);
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_client_app_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_client_app_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_coded_concept_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_coded_concept_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_contact_point_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_contact_point_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_data_quality_metric_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_data_quality_metric_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_data_quality_metric_role_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_data_quality_metric_role_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_data_quality_value_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_data_quality_value_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_delivery_stream_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_delivery_stream_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_device_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_device_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_device_model_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_device_model_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_device_model_role_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_device_model_role_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_device_role_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_device_role_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_functional_expression_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_functional_expression_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_functional_expression_role_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_functional_expression_role_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_identifier_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_identifier_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_image_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_image_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_image_role_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_image_role_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_library_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_library_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_location_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_location_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_location_event_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_location_event_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_location_role_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_location_role_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_organization_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_organization_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_organization_role_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_organization_role_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_person_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_person_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_person_role_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_person_role_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_postal_address_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_postal_address_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_postal_address_component_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_postal_address_component_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_sensor_study_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_sensor_study_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_sensor_subject_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_sensor_subject_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_sensor_subject_role_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_sensor_subject_role_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_token_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_token_id is not null;
CREATE UNIQUE INDEX ON tracking_events (ico_tracking_events_vocabulary_id, type_id, client_app_id, user_id, during_start) where ico_tracking_events_vocabulary_id is not null;