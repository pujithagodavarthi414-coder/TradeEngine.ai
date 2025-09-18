using formioModels;
using System;
using System.Collections.Generic;
using formioCommon.Constants;
using formioModels.Data;

namespace formioHelpers.Data
{
    public class DataSourceValidations
    {
        public static bool ValidateDataSource(DataSourceInputModel dataSourceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            
            if (string.IsNullOrEmpty(dataSourceUpsertInputModel.Name))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NameNotFound
                });
            }

            if (string.IsNullOrEmpty(dataSourceUpsertInputModel.DataSourceType))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSourceTypeNotFound
                });
            }

            if (dataSourceUpsertInputModel.Name?.Length > 100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NameMaxLength
                });
            }

            return validationMessages.Count <= 0;
        }
        public static bool ValidateUpdateDataSource(DataSourceInputModel dataSourceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(dataSourceUpsertInputModel.Name))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NameNotFound
                });
            }

            if (string.IsNullOrEmpty(dataSourceUpsertInputModel.DataSourceType))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSourceTypeNotFound
                });
            }
            if (dataSourceUpsertInputModel.Id == Guid.Empty || dataSourceUpsertInputModel.Id == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSourceIdNotFound
                });
            }

            if (dataSourceUpsertInputModel.Name?.Length > 100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NameMaxLength
                });
            }

            return validationMessages.Count <= 0;
        }
        public static bool ValidateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (dataSetUpsertInputModel.DataSourceId == Guid.Empty || dataSetUpsertInputModel.DataSourceId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSourceIdNotFound
                });
            }
            return validationMessages.Count <= 0;
        }
        public static bool ValidateUpdateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (dataSetUpsertInputModel.DataSourceId == Guid.Empty || dataSetUpsertInputModel.DataSourceId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSourceIdNotFound
                });
            }
            if (dataSetUpsertInputModel.Id == Guid.Empty || dataSetUpsertInputModel.Id == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSetIdNotFound
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpdateDataSetUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages)
        {

            if (dataSetUpsertInputModel.DataSourceId == Guid.Empty || dataSetUpsertInputModel.DataSourceId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSourceIdNotFound
                });
            }
            if (dataSetUpsertInputModel.Id == Guid.Empty || dataSetUpsertInputModel.Id == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSetIdNotFound
                });
            }
            return validationMessages.Count <= 0;
        }
        public static bool ValidateSearchDataSet(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (id == Guid.Empty || id == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSetIdNotFound
                });
            }

            return validationMessages.Count <= 0;
        }
        public static bool ValidateSearchDataSets(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (dataSetSearchCriteriaInputModel.IsArchived == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.IsArchivedShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateSearchDataSetsUnAuth(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {

            if (dataSetSearchCriteriaInputModel.IsArchived == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.IsArchivedShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }
        public static bool ValidateSearchDataSources(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (dataSourceSearchCriteriaInputModel.IsArchived == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.IsArchivedShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }
        public static bool ValidateSearchDataSourcesUnAuth(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {

            if (dataSourceSearchCriteriaInputModel.IsArchived == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.IsArchivedShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
