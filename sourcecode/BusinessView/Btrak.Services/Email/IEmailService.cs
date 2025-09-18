using Btrak.Models;
using BTrak.Common;


namespace Btrak.Services.Email
{
    public interface IEmailService
    {
        void SendEmailToUserWithContent(Models.Email.EmailModel emailModel);
        void SendMail(LoggedInContext loggedInContext, EmailGenericModel emailGenericModel);
        void SendEmailWithKeys(EmailGenericModel emailGenericModel);
        void SendSMS(string mobileNo, string messageBody, LoggedInContext loggedInContext);
    }
}
