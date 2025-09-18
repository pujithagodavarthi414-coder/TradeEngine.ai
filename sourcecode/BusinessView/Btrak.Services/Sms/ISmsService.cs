using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Comments;
using Btrak.Models.Crm.Call;
using Btrak.Models.Crm.Sms;
using BTrak.Common;

namespace Btrak.Services.SMS
{
    public interface ISmsService
    {
        Guid? SendMessage(SendSmsInputModel sendSmsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SMSServiceResponse SendOTP(SendSmsInputModel sendSmsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SMSServiceResponse ValidateOTP(SendSmsInputModel sendSmsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSmsTemplate(SmsTemplateInputModel smsTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SmsTemplateOutputModel> SearchSmsTemplate(SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SmsTemplateOutputModel GetSmsTemplateById(SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}