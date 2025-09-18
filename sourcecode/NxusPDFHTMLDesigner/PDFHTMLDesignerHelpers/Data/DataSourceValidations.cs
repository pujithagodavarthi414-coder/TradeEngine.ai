using PDFHTMLDesignerModels;
using System;
using System.Collections.Generic;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;

namespace PDFHTMLDesignerHelpers.Data
{
    public class DataSourceValidations
    {
        public static bool ValidateDataSource(HTMLDatasetInputModel dataSourceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            
            if (string.IsNullOrEmpty(dataSourceUpsertInputModel.HTMLFile))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error, 
                    ValidationMessaage = ValidationMessages.NameNotFound
                });
            }

            if (string.IsNullOrEmpty(dataSourceUpsertInputModel.HTMLFile))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DataSourceTypeNotFound
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
        
    }
}
