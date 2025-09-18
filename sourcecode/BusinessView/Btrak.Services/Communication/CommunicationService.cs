using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using BTrak.Common;

namespace Btrak.Services.Communication
{
    public class CommunicationService : ICommunicationService
    {
        public void SendMail(string from, string to, string[] bcc, string subject, string template, Attachment[] attachments)
        {
            try
            {
                //TODO: Review this code

                SmtpClient smtp = new SmtpClient
                {
                    Host = "smtp.gmail.com",
                    Port = 587,
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(ConfigurationManager.AppSettings["SmtpEmail"], ConfigurationManager.AppSettings["SmtpPassword"])
                };

                using (var message = new MailMessage(from, to)
                {
                    Subject = subject,
                    Body = template,
                    IsBodyHtml = true
                })
                {
                    if (attachments != null && attachments.Length > 0)
                    {
                        foreach (var attachment in attachments)
                        {
                            if (attachment != null)
                            {
                                message.Attachments.Add(attachment);
                            }
                        }
                    }
                    smtp.Send(message);
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMail", "CommunicationService ", ex.Message), ex);

            }
        }
    }
}
