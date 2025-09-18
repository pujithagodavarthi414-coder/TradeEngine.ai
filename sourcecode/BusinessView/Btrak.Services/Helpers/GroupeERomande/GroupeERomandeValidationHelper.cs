using Btrak.Models;
using Btrak.Models.EntryForm;
using Btrak.Models.GrERomande;
using Btrak.Models.MessageFieldType;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.GroupeERomande
{
    public class GroupeERomandeValidationHelper
    {
        public static bool UpsertGroupeERomandeValidation(GrERomandeInputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGroupeERomandeValidation", "grERomandeInput", grERomandeInput, "GroupeERomande Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (grERomandeInput.SiteId == null || grERomandeInput.SiteId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptySiteId)
                });
            }
            if (grERomandeInput.GrdId == null || grERomandeInput.GrdId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyGrdId)
                });
            }
            if (grERomandeInput.BankId == null || grERomandeInput.BankId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyGrdId)
                });
            }
            if (grERomandeInput.Month == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyMonth)
                });
            }
            if (grERomandeInput.StartDate == null || grERomandeInput.StartDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyStartDate)
                });
            }
            if (grERomandeInput.EndDate == null || grERomandeInput.EndDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyEndDate)
                });
            }
            if (grERomandeInput.Term == null || grERomandeInput.Term.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTerm)
                });
            }
            if (string.IsNullOrEmpty(grERomandeInput.Year.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyYear)
                });
            }
            if (string.IsNullOrEmpty(grERomandeInput.Production.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyProduction)
                });
            }
            if (string.IsNullOrEmpty(grERomandeInput.Reprise.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyReprise)
                });
            }
            if (string.IsNullOrEmpty(grERomandeInput.Facturation.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFacturation)
                });
            }
            if (string.IsNullOrEmpty(grERomandeInput.GridInvoice.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyGridInvoice)
                });
            }
            if (string.IsNullOrEmpty(grERomandeInput.GridInvoiceDate.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyGridInvoiceDate)
                });
            }
            //if (string.IsNullOrEmpty(grERomandeInput.HauteTariff.ToString()))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.NotEmptyHauteTariff)
            //    });
            //}
            //if (string.IsNullOrEmpty(grERomandeInput.BasTariff.ToString()))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.NotEmptyBasTariff)
            //    });
            //}
            //if (string.IsNullOrEmpty(grERomandeInput.Distribution.ToString()))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.NotEmptyDistribution)
            //    });
            //}
            //if (string.IsNullOrEmpty(grERomandeInput.GreFacturation.ToString()))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.NotEmptyGreFacturation)
            //    });
            //}
            //if (string.IsNullOrEmpty(grERomandeInput.AdministrationRomandeE.ToString()))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.NotEmptyAdministrationRomandeE)
            //    });
            //}
            if (string.IsNullOrEmpty(grERomandeInput.AutoCTariff.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyAutoCTariff)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEntryFormFieldValidation(EntryFormUpsertInputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGroupeERomandeValidation", "grERomandeInput", grERomandeInput, "GroupeERomande Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(grERomandeInput.DisplayName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyDisplayName)
                });
            }
           
            if((!string.IsNullOrEmpty(grERomandeInput.DisplayName)) && grERomandeInput.DisplayName.Length > 250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.DisplayNameNotExceeded)
                });
            }
            
            return validationMessages.Count <= 0;
        }

        public static bool UpsertMessageFieldValidation(MessageFieldTypeOutputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGroupeERomandeValidation", "grERomandeInput", grERomandeInput, "GroupeERomande Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(grERomandeInput.DisplayText) || (grERomandeInput.IsArchived == null || grERomandeInput.IsArchived == false))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyDisplayText)
                });
            }

           
            return validationMessages.Count <= 0;
        }

        public static bool UpsertEntryFormFieldTypeValidation(FieldTypeSearchModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGroupeERomandeValidation", "grERomandeInput", grERomandeInput, "GroupeERomande Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(grERomandeInput.FieldTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFieldTypeName)
                });
            }
            
            if ((!string.IsNullOrEmpty(grERomandeInput.FieldTypeName)) && grERomandeInput.FieldTypeName.Length > 250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.FieldNameNotExceeded)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
