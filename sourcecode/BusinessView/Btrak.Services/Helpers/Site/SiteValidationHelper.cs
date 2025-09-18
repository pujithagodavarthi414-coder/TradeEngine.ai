using Btrak.Models;
using Btrak.Models.Site;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Btrak.Services.Helpers.Site
{
    public class SiteValidationHelper
    {
        public static bool UpsertSiteValidations(SiteUpsertModel siteUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSiteValidations", "SiteValidationHelper", siteUpsertModel, "HrManagement Validations Helper"));

            if (string.IsNullOrEmpty(siteUpsertModel.Name))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySiteName
                });
            }

            if (!string.IsNullOrEmpty(siteUpsertModel.Name))
            {
                if (siteUpsertModel.Name.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.SiteNameLengthExceeded
                    });
                }
            }
            if (string.IsNullOrEmpty(siteUpsertModel.RoofRentalAddress))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyAddress
                });
            }

            if (!string.IsNullOrEmpty(siteUpsertModel.RoofRentalAddress))
            {
                if (siteUpsertModel.RoofRentalAddress.Length > 250)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.CompanyAddressLengthExceed
                    });
                }
            }
            if (siteUpsertModel.Date == null)
            {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.DateIsRequired
                    });
            }
            if (string.IsNullOrEmpty(siteUpsertModel.ParcellNo))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyAddress
                });
            }

            if (!string.IsNullOrEmpty(siteUpsertModel.ParcellNo))
            {
                if (siteUpsertModel.ParcellNo.Length > 250)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.CompanyAddressLengthExceed
                    });
                }
            }

            if (string.IsNullOrEmpty(siteUpsertModel.Email))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmail
                });
            }

            if (!string.IsNullOrEmpty(siteUpsertModel.Email))
            {
                if (siteUpsertModel.Email.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EmailLengthExceeded
                    });
                }
                string email = siteUpsertModel.Email;
                Regex regex = new Regex(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$");
                Match match = regex.Match(email);
                if (!match.Success)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EmailFormat
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

    }
}
