using System.Net.Mail;

namespace Btrak.Services.Communication
{
    public interface ICommunicationService
    {
        void SendMail(string from, string to, string[] bcc, string subject, string message, Attachment[] attachments);
    }
}
