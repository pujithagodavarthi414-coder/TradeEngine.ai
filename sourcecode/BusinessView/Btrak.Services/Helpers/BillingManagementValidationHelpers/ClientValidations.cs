using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Btrak.Services.Helpers.BillingManagement
{
    public class ClientValidations
    {
        public static bool ValidateUpsertClient(UpsertClientInputModel upsertClientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            //string pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";

            if (String.IsNullOrEmpty(upsertClientInputModel.FirstName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFirstName
                });
            }

            if (String.IsNullOrEmpty(upsertClientInputModel.LastName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLastName
                });
            }

            if (String.IsNullOrEmpty(upsertClientInputModel.Email))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmail
                });

            }

            //if (!string.IsNullOrEmpty(upsertClientInputModel.Email) && !Regex.IsMatch(upsertClientInputModel.Email, pattern))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.EmailFormatError
            //    });

            //}

            if (String.IsNullOrEmpty(upsertClientInputModel.CompanyName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyName
                });
            }

            if (String.IsNullOrEmpty(upsertClientInputModel.CountryId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCountryId
                });
            }

            if (!string.IsNullOrEmpty(upsertClientInputModel.FirstName) && upsertClientInputModel.FirstName.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FirstNameLengthExceeded
                });
            }

            if (!string.IsNullOrEmpty(upsertClientInputModel.LastName) && upsertClientInputModel.LastName.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.LastNameLengthExceeded
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertClientSecondaryContact(UpsertClientSecondaryContactModel upsertClientSecondaryContactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            string pattern = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$";

            if (upsertClientSecondaryContactModel.ClientId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyClientId
                });
            }

            if (String.IsNullOrEmpty(upsertClientSecondaryContactModel.FirstName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFirstName
                });
            }

            if (String.IsNullOrEmpty(upsertClientSecondaryContactModel.LastName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLastName
                });
            }

            if (String.IsNullOrEmpty(upsertClientSecondaryContactModel.Email))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmail
                });
            }

            if (!string.IsNullOrEmpty(upsertClientSecondaryContactModel.Email) && !Regex.IsMatch(upsertClientSecondaryContactModel.Email, pattern))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.EmailFormatError
                });

            }

            if (!string.IsNullOrEmpty(upsertClientSecondaryContactModel.FirstName) && upsertClientSecondaryContactModel.FirstName.Length > AppConstants.InputWithMaxSize50 )
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FirstNameLengthExceeded
                });
            }

            if (!string.IsNullOrEmpty(upsertClientSecondaryContactModel.LastName) &&  upsertClientSecondaryContactModel.LastName.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.LastNameLengthExceeded
                });
            }

            if (!string.IsNullOrEmpty(upsertClientSecondaryContactModel.MobileNo) && upsertClientSecondaryContactModel.MobileNo.Length > AppConstants.InputWithMaxSize20)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MobileNoLengthExceeded
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertClientProjects(UpsertClientProjectsModel upsertClientProjectsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (String.IsNullOrEmpty(upsertClientProjectsModel.ClientId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyClientId
                });
            }

            if (String.IsNullOrEmpty(upsertClientProjectsModel.ProjectId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertSCOGeneration(SCOUpsertInputModel sCOUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (String.IsNullOrEmpty(sCOUpsertInputModel.LeadSubmissionId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeadSubmissionId
                });
            }

            if (sCOUpsertInputModel.CreditsAllocated<=0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotZeroCredits
                });
            }

            return validationMessages.Count <= 0;
        }
        public static bool ValidateUpsertPurchaseContract(MasterContractInputModel masterContractInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (String.IsNullOrEmpty(masterContractInputModel.ClientId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyClientId
                });
            }

            if (String.IsNullOrEmpty(masterContractInputModel.GradeId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayGradeId
                });
            }

            if (String.IsNullOrEmpty(masterContractInputModel.ProductId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ProductIdIsRequired
                });
            }

            if (String.IsNullOrEmpty(masterContractInputModel.ContractNumber))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyContractNumber
                });
            }

            if (masterContractInputModel.ContractDateFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyContractDateFrom
                });
            }
            if (masterContractInputModel.ContractDateTo == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyContractDateTo
                });
            }
            if (masterContractInputModel.RateOrTon <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PriceShouldBeGreaterThanZero
                });
            }
            if (masterContractInputModel.ContractQuantity <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.QuantityShouldBeGreaterThanZero
                });
            }
            if (masterContractInputModel.ContractDateTo < masterContractInputModel.ContractDateFrom)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ContractDatesShouldBeCorrect
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertShipmentExecutions(PurchaseShipmentExecutionInputModel purchaseShipmentExecutionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (String.IsNullOrEmpty(purchaseShipmentExecutionInputModel.ShipmentNumber) || purchaseShipmentExecutionInputModel.ShipmentNumber==" ")
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ShipmentNumberRequired
                });
            }
            if (String.IsNullOrEmpty(purchaseShipmentExecutionInputModel.PortDischargeId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DischargePortIsRequired
                });
            }
            if (String.IsNullOrEmpty(purchaseShipmentExecutionInputModel.PortLoadId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.LoadPortIsRequired
                });
            }
            if (purchaseShipmentExecutionInputModel.PortLoadId == purchaseShipmentExecutionInputModel.PortDischargeId)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PortsShouldBeDifferent
                });
            }
            if (purchaseShipmentExecutionInputModel.ShipmentQuantity<=0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ShipmentQuantityRequired
                });
            }
            if (purchaseShipmentExecutionInputModel.ShipmentQuantity < purchaseShipmentExecutionInputModel.BLQuantity)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ShipmentQuantitiesShouldBeLessThanContractQuantity
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ValidateGetShipmentExecutionBLById(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (String.IsNullOrEmpty(purchaseShipmentExecutionSearchInputModel.PurchaseShipmentBLId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PurchaseShipmentBlIdRequired
                });
            }
            return validationMessages.Count <= 0;
        }
        public static bool ValidateGetShipmentExecutionBLs(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (String.IsNullOrEmpty(purchaseShipmentExecutionSearchInputModel.PurchaseShipmentId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PurchaseShipmentIdRequired
                });
            }
            return validationMessages.Count <= 0;
        }
    }
    }