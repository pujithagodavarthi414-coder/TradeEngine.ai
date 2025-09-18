using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using BTrak.Common;
using BTrak.Common.Constants;
using Btrak.Dapper.Dal.Partial;
using Btrak.Services.CompanyStructure;
using Hangfire;
using System.Threading.Tasks;
using Btrak.Services.CRM;
using Newtonsoft.Json;
using System.IO;
using System.Web;
using Btrak.Models.Crm.Sms;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Models.Crm.Call;
using Btrak.Models.Crm;
using RestSharp;

namespace Btrak.Services.SMS
{
    public class SmsService : ISmsService
    {
        private readonly SmsRepository _smsRepository;
        private readonly IAuditService _auditService;
        private readonly ExternalServiceProviderRepository _externalServiceProviderRepository;

        public SmsService(SmsRepository smsRepository, IAuditService auditService, ExternalServiceProviderRepository externalServiceProviderRepository)
        {
            _smsRepository = smsRepository;
            _auditService = auditService;
            _externalServiceProviderRepository = externalServiceProviderRepository;
        }

        public SmsTemplateOutputModel GetSmsTemplateById(SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search SMS template", "SMS Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchCommentsCommandId, smsTemplateSearchTemplateInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, smsTemplateSearchTemplateInputModel, validationMessages))
            {
                return null;
            }

            SmsTemplateOutputModel template = _smsRepository.GetSmsTemplateById(smsTemplateSearchTemplateInputModel, loggedInContext, validationMessages);

            return template;
        }

        public List<SmsTemplateOutputModel> SearchSmsTemplate(SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search SMS template", "SMS Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchCommentsCommandId, smsTemplateSearchTemplateInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, smsTemplateSearchTemplateInputModel, validationMessages))
            {
                return null;
            }

            List<SmsTemplateOutputModel> templateOutputModels = _smsRepository.SearchSmsTemplate(smsTemplateSearchTemplateInputModel, loggedInContext, validationMessages);

            return templateOutputModels;
        }

        public Guid? SendMessage(SendSmsInputModel sendSmsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search SMS template", "SMS Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchCommentsCommandId, sendSmsInputModel, loggedInContext);

            Guid? messageId = _smsRepository.SendMessage(sendSmsInputModel, loggedInContext, validationMessages);

            return messageId;
        }

        public SMSServiceResponse SendOTP(SendSmsInputModel sendSmsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Send OTP", "SMS Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchCommentsCommandId, sendSmsInputModel, loggedInContext);

            SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel = new SmsTemplateSearchTemplateInputModel();
            smsTemplateSearchTemplateInputModel.CompanyId = loggedInContext.CompanyGuid;
            smsTemplateSearchTemplateInputModel.IsActive = true;
            smsTemplateSearchTemplateInputModel.TemplateName = "OTP";
            smsTemplateSearchTemplateInputModel.UserId = sendSmsInputModel.UserId;
            SmsTemplateOutputModel smsTemplateOutputModel = _smsRepository.GetSmsTemplateById(smsTemplateSearchTemplateInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (smsTemplateOutputModel.TemplateCode != null)
            {
                //https://api.msg91.com/api/v5/otp?extra_param={"Param1":"Value1", "Param2":"Value2", "Param3": "Value3"}&authkey=Authentication Key&template_id=Template ID&mobile=Mobile Number with Country Code&invisible=1
                SMSVariables smsVariables = GetSMSVariables(loggedInContext.LoggedInUserId == Guid.Empty ? sendSmsInputModel.UserId.Value : loggedInContext.LoggedInUserId, validationMessages);
                string url = string.Empty;
                string requestType = string.Empty;
                if (sendSmsInputModel.IsResend)
                {
                    requestType = "otp/retry";
                    const string Format = "mobile={0}&authkey={1}";
                    url = string.Format(Format, sendSmsInputModel.MobileNumber, smsVariables.AuthenticationKey);
                }
                else
                {
                    requestType = "otp";
                    string extraParam = "{\"##COMPANY_NAME##\":\"Mobile Login\"}";
                    url = $"extra_param={HttpUtility.UrlEncode(extraParam)}&authkey={HttpUtility.UrlEncode(smsVariables.AuthenticationKey)}&template_id={HttpUtility.UrlEncode(smsTemplateOutputModel.TemplateCode)}&mobile={HttpUtility.UrlEncode(sendSmsInputModel.MobileNumber)}";

                    //url = string.Format(Format, smsVariables.API, smsVariables.AuthenticationKey, smsTemplateOutputModel.TemplateCode, sendSmsInputModel.MobileNumber);
                }

                SMSServiceResponse smsServiceResponse = SendOtpViaRestClient(url, smsVariables.API, requestType);
                return smsServiceResponse;
            }
            return null;
        }

        public Guid? UpsertSmsTemplate(SmsTemplateInputModel smsTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search SMS template", "SMS Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchCommentsCommandId, smsTemplateInputModel, loggedInContext);

            Guid? messageId = _smsRepository.UpsertSmsTemplate(smsTemplateInputModel, loggedInContext, validationMessages);

            return messageId;
        }

        public SMSServiceResponse ValidateOTP(SendSmsInputModel sendSmsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Validate Otp", "SMS Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchCommentsCommandId, sendSmsInputModel, loggedInContext);

            SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel = new SmsTemplateSearchTemplateInputModel();
            smsTemplateSearchTemplateInputModel.CompanyId = loggedInContext.CompanyGuid;
            smsTemplateSearchTemplateInputModel.IsActive = true;
            smsTemplateSearchTemplateInputModel.TemplateName = "OTP";
            smsTemplateSearchTemplateInputModel.UserId = sendSmsInputModel.UserId;
            SmsTemplateOutputModel smsTemplateOutputModel = _smsRepository.GetSmsTemplateById(smsTemplateSearchTemplateInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (smsTemplateOutputModel.TemplateCode != null)
            {
                //https://api.msg91.com/api/v5/otp?extra_param={"Param1":"Value1", "Param2":"Value2", "Param3": "Value3"}&authkey=Authentication Key&template_id=Template ID&mobile=Mobile Number with Country Code&invisible=1
                SMSVariables smsVariables = GetSMSVariables(loggedInContext.LoggedInUserId == Guid.Empty ? sendSmsInputModel.UserId.Value : loggedInContext.LoggedInUserId, validationMessages);
                string url = string.Empty;

                const string Format = "mobile={0}&otp={1}&authkey={2}";
                url = string.Format(Format,HttpUtility.UrlEncode(sendSmsInputModel.MobileNumber), HttpUtility.UrlEncode(sendSmsInputModel.OtpNumber.ToString()), HttpUtility.UrlEncode(smsVariables.AuthenticationKey));

                SMSServiceResponse smsServiceResponse = SendOtpViaRestClient(url, smsVariables.API, "otp/verify");
                return smsServiceResponse;
            }
            return null;
        }

        public SMSVariables GetSMSVariables(Guid loggedInUserId, List<ValidationMessage> validationMessages)
        {
            SMSVariables smsVariable;
            List<ExpernalServiceProviderOutputModel> expernalServiceProviderOutputModels = _externalServiceProviderRepository.GetExternalServiceProperties("SMS", loggedInUserId, validationMessages);

            if (expernalServiceProviderOutputModels != null)
            {
                smsVariable = new SMSVariables();
                smsVariable.API = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "API").PropertyValue;
                smsVariable.AuthenticationKey = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "AuthToken").PropertyValue;
                return smsVariable;
            }
            else
            {
                return null;
            }
        }

        public SMSServiceResponse SendOtpViaRestClient(string url, string api, string requestType)
        {
            string encoded = $"{api}/{requestType}?{url}";
            RestClient client = new RestClient(encoded);
            RestRequest request = new RestRequest();
            request.Method = Method.GET;
            request.AddHeader("content-type", "application/json");
            var response = client.Execute(request);
            string content = response.Content;
            SMSServiceResponse sMSServiceResponse = JsonConvert.DeserializeObject<SMSServiceResponse>(content);
            return sMSServiceResponse;
        }
    }
}