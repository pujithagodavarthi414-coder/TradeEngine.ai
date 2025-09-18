using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;

namespace BTrak.Common
{
    public static class FormatHelper
    {
        //Review this code

        public static void SendMail(LoggedInContext loggedInContext, EmailGenericModel emailGenericModel)
        {
            try
            {
                if(string.IsNullOrEmpty(emailGenericModel.SmtpMail) || string.IsNullOrEmpty(emailGenericModel.SmtpPassword) || string.IsNullOrEmpty(emailGenericModel.SmtpServer) || string.IsNullOrEmpty(emailGenericModel.SmtpServerPort))
                {
                    emailGenericModel.SmtpMail = ConfigurationManager.AppSettings["SmtpEmail"];
                    emailGenericModel.SmtpPassword = ConfigurationManager.AppSettings["SmtpPassword"];
                    emailGenericModel.SmtpServer = ConfigurationManager.AppSettings["SmtpServer"];
                    emailGenericModel.SmtpServerPort = ConfigurationManager.AppSettings["SmtpServerPort"];
                }

                SmtpClient smtp = new SmtpClient
                {
                    Host = emailGenericModel.SmtpServer,
                    Port = Int32.Parse(emailGenericModel.SmtpServerPort),
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(emailGenericModel.SmtpMail, emailGenericModel.SmtpPassword)
                };

                using (var message = new MailMessage()
                {

                    Subject = emailGenericModel.Subject,
                    Body = emailGenericModel.HtmlContent,
                    IsBodyHtml = true
                })
                {
                    try
                    {
                        //To mails
                        if (emailGenericModel.ToAddresses != null && emailGenericModel.ToAddresses.Length > 0)
                        {

                            foreach (var tomail in emailGenericModel.ToAddresses)
                            {
                                message.To.Add(new MailAddress(tomail));
                            }
                        }

                        //CC mails
                        if (emailGenericModel.CCMails != null && emailGenericModel.CCMails.Length > 0)
                        {
                            foreach (var ccmail in emailGenericModel.CCMails)
                            {
                                message.CC.Add(new MailAddress(ccmail));
                            }
                        }

                        //BCC mails
                        if (emailGenericModel.BCCMails != null && emailGenericModel.BCCMails.Length > 0)
                        {
                            foreach (var bccmail in emailGenericModel.BCCMails)
                            {
                                message.Bcc.Add(new MailAddress(bccmail));
                            }
                        }
                        //IsPdf
                        if(emailGenericModel.IsPdf == null)
                        {
                            emailGenericModel.IsPdf = false;
                        }

                        //Attachments
                        if (emailGenericModel.MailAttachments != null && emailGenericModel.MailAttachments.Count > 0)
                        {
                            foreach (var attment in emailGenericModel.MailAttachments)
                            {
                                if (emailGenericModel.IsPdf != null && emailGenericModel.IsPdf == true)
                                {
                                    var pdfFileName = Guid.NewGuid() + "-" + DateTime.Now.ToString("yyyy/M/dd");
                                    var attachment = new Attachment(attment, pdfFileName, MediaTypeNames.Application.Pdf);
                                    message.Attachments.Add(attachment);
                                }
                                else if (emailGenericModel.IsPdf != null && emailGenericModel.IsPdf == false)
                                {
                                    var excelFileName = Guid.NewGuid() + "-" + DateTime.Now.ToString("yyyy/M/dd") + ".xlsx";
                                    var attachment = new Attachment(attment, excelFileName);
                                    attachment.ContentType = new ContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                                    message.Attachments.Add(attachment);
                                }
                            }
                        }

                        //Send mail
                        smtp.Send(message);
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMail", "FormatHelperClass", exception.Message), exception);
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMail", "FormatHelperClass", exception.Message), exception);
            }
        }
    }
}
