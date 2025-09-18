using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Models.PaymentMethod;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Helpers.BillingManagementValidationHelpers
{
    public class LeadTemplateValidationHelper
    {
        public static bool ValidateUpsertLeadTemplate(LeadTemplateUpsertInputModel upsertLeadTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
           
            if (String.IsNullOrEmpty(upsertLeadTemplateInputModel.FormName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFormName
                });
            }

            if (!string.IsNullOrEmpty(upsertLeadTemplateInputModel.FormName) && upsertLeadTemplateInputModel.FormName.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FormNameLengthExceeded
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertLeadContract(LeadContractSubmissionsInputModel leadContractSubmissionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (leadContractSubmissionsInputModel.SalesPersonId == null || leadContractSubmissionsInputModel.SalesPersonId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserId
                });
            }
            //if (leadContractSubmissionsInputModel.ContractId == null || leadContractSubmissionsInputModel.ContractId == Guid.Empty)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyContractTypeId
            //    });
            //}
            if (leadContractSubmissionsInputModel.ClientId == null || leadContractSubmissionsInputModel.ClientId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyClientId
                });
            }
            if (leadContractSubmissionsInputModel.ProductId == null || leadContractSubmissionsInputModel.ProductId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ProductIdIsRequired
                });
            }
            if (leadContractSubmissionsInputModel.GradeId == null || leadContractSubmissionsInputModel.GradeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayGradeId
                });
            }
            //if (leadContractSubmissionsInputModel.StatusId == null || leadContractSubmissionsInputModel.StatusId == Guid.Empty)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyStatusId
            //    });
            ////}
            //if (leadContractSubmissionsInputModel.CountryOriginId == null || leadContractSubmissionsInputModel.CountryOriginId == Guid.Empty)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.CountryShouldNotBeNull
            //    });
            //}
            if (leadContractSubmissionsInputModel.LeadDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DateIsRequired
                });
            }
            if (leadContractSubmissionsInputModel.QuantityInMT < 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FoodItemQuantityIsNotEmpty
                });
            }
            return validationMessages.Count <= 0;
        }
        public static bool UpsertPaymentTerm(PaymentTermInputModel paymentTermInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Payment Term", "paymentTermInputModel", paymentTermInputModel, "LeadTemplate Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(paymentTermInputModel.Name))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPaymentMethodName
                });
            }

            if (!string.IsNullOrEmpty(paymentTermInputModel.Name))
            {
                if (paymentTermInputModel.Name.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.PaymentMethodNameLengthExceeded
                    });
                }

            }

            return validationMessages.Count <= 0;
        }
        public static bool UpsertLeadInvoice(ClientCreditsUpsertInputModel clientCreditsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLeadInvoice", "clientCreditsUpsertInputModel", clientCreditsUpsertInputModel, "LeadTemplate Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (clientCreditsUpsertInputModel.LeadId == null || clientCreditsUpsertInputModel.LeadId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeadSubmissionId
                });
            }

            if (clientCreditsUpsertInputModel.PaidAmount <= 0)
            {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.AmountLessThanZero
                    });
            }

            return validationMessages.Count <= 0;
        }
        public static bool CloseLead(Guid? LeadId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CloseLead", "clientCreditsUpsertInputModel", LeadId, "LeadTemplate Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (LeadId == null || LeadId  == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeadSubmissionId
                });
            }
            return validationMessages.Count <= 0;
        }

    }
}
