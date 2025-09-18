using AuthenticationServices.Common;
using AuthenticationServices.Models.Email;

namespace AuthenticationServices.Services.Email
{
    public interface IEmailService
    {
        void SendEmailToUserWithContent(EmailModel emailModel);
        void SendMail(LoggedInContext loggedInContext, EmailGenericModel emailGenericModel);
        void SendEmailWithKeys(EmailGenericModel emailGenericModel);
    }
}
