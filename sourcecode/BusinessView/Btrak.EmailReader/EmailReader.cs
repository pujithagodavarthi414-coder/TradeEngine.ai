using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using Btrak.EmailReader.Repositories;
using Btrak.Models;
using Btrak.Models.DailyUploadExcels;
using Btrak.Models.EmailReader;

using BTrak.Common;
using OpenPop.Mime;
using OpenPop.Pop3;

public class EmailReader
{
    private readonly HashSet<string> processedEmailIds = new HashSet<string>();
    private readonly string processedEmailsFilePath = "processedEmails.txt";

    public EmailReader()
    {
        LoadProcessedEmailIds();
    }

    private void LoadProcessedEmailIds()
    {
        if (File.Exists(processedEmailsFilePath))
        {
            var lines = File.ReadAllLines(processedEmailsFilePath);
            foreach (var line in lines)
            {
                processedEmailIds.Add(line);
            }
        }
    }

    private void SaveProcessedEmailId(string emailId)
    {
        File.AppendAllText(processedEmailsFilePath, emailId + Environment.NewLine);
        processedEmailIds.Add(emailId);
    }

    public void GetEmailsList()
    {
        try
        {
            var excelRepository = new ExcelRepository();
            Console.WriteLine("Entering into EmailsList");
            //LoggedInContext loggedInUser = new LoggedInContext()
            //{
            //    LoggedInUserId = new Guid(ConfigurationManager.AppSettings["CustomAppImportsUserId"].ToString()),
            //    CompanyGuid = new Guid(ConfigurationManager.AppSettings["CustomAppCompanyId"].ToString())
            //};
            var validationMessages = new List<ValidationMessage>();
            List<EmailsReaderDetailsModel> companySettingsDetails = excelRepository.GetDetailsForEmailsReader(validationMessages);
            companySettingsDetails = companySettingsDetails.Where(x => !string.IsNullOrEmpty(x.Email) && !string.IsNullOrEmpty(x.Password) && !string.IsNullOrEmpty(x.Subject)).ToList();
            Console.WriteLine("CompanySettingsDetailsCount:" + companySettingsDetails.Count);
            foreach (var companySettings in companySettingsDetails)
            {
                if(!string.IsNullOrEmpty(companySettings.Email) && !string.IsNullOrEmpty(companySettings.Password) && !string.IsNullOrEmpty(companySettings.Subject))
                {
                    // Register the code pages encoding provider
                    Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
                    string authToken = companySettings.AuthToken;
                    var userName = companySettings.Email;
                    var password = companySettings.Password;
                    List<EmailReaderModel> emails = new List<EmailReaderModel>();
                    //loggedInUser.CompanyGuid = companySettings.CompanyId;
                    //loggedInUser.LoggedInUserId = companySettings.UserId;

                    using (Pop3Client client = new Pop3Client())
                    {
                        client.Connect("outlook.office365.com", 995, true);
                        client.Authenticate(userName, password, OpenPop.Pop3.AuthenticationMethod.UsernameAndPassword);

                        int messageCount = client.GetMessageCount();
                        string? configuredSubject = companySettings.Subject;
                        for (int i = 1; i <= messageCount; i++)
                        {
                            Message message = client.GetMessage(i);
                            string subject = message.Headers.Subject;
                            string body = message.FindFirstPlainTextVersion()?.GetBodyAsText() ?? string.Empty;
                            DateTime sentDate = message.Headers.DateSent;

                            // Create a unique identifier for the email
                            string emailId = $"{sentDate.ToString("yyyyMMddHHmmssfff")}-{message.Headers.MessageId}";
                            if (processedEmailIds.Contains(emailId))
                            {
                                Console.WriteLine($"Skipping already processed email with ID: {emailId}");
                                continue;
                            }

                            if (subject != configuredSubject)
                            {
                                Console.WriteLine($"Skipping not configured email with subject: {subject}");
                                continue;
                            }

                            List<Attachments> fileAttachments = new List<Attachments>();
                            foreach (var attachment in message.FindAllAttachments())
                            {
                                byte[] attachmentData = attachment.Body;
                                string fileName = attachment.FileName;
                                string contentType = attachment.ContentType.MediaType;
                                string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(fileName);
                                string fileExtension = Path.GetExtension(fileName);
                                string? saveDirectory = ConfigurationManager.AppSettings["DownloadsPath"]; // Specify your save directory
                                string updatedFileName = fileNameWithoutExtension +"_"+ sentDate.ToString("yyyyMMddHHmmssfff") + fileExtension;
                                string? saveFilePath = Path.Combine(saveDirectory, updatedFileName);

                                Directory.CreateDirectory(saveDirectory);
                                // Save the attachment data to a file
                                File.WriteAllBytes(saveFilePath, attachmentData);

                                var excelModel = new DailyUploadExcelsInputModel
                                {
                                    ExcelSheetName = updatedFileName,
                                    MailAddress = userName,
                                    FilePath = saveFilePath,
                                    AuthToken = authToken,
                                    CompanyId = companySettings.CompanyId
                                    
                                };
                                var Id = excelRepository.UpsertExcelToCustomApplicationDetails(excelModel, false, companySettings.UserId, validationMessages);
                                fileAttachments.Add(new Attachments
                                {
                                    FileName = updatedFileName,
                                    Size = attachmentData.Length,
                                    ContentType = contentType,
                                    FilePath = saveFilePath
                                });
                            }

                            var newEmail = new EmailReaderModel
                            {
                                Subject = subject,
                                Message = body,
                                MessageNumber = i,
                                MessageSentDate = sentDate,
                                FromAddress = message.Headers.From.Address,
                                FileAttachments = fileAttachments
                            };

                            if (newEmail.FileAttachments != null && newEmail.FileAttachments.Count > 0)
                            {
                                foreach (var attch in newEmail.FileAttachments)
                                {
                                    Console.WriteLine("FileName: " + attch.FileName);
                                    Console.WriteLine("FileSize:" + attch.Size);
                                    Console.WriteLine("FilePath:" + attch.FilePath);
                                }
                            }
                            Console.WriteLine(new string('-', 50));

                            emails.Add(newEmail);

                            // Mark email as processed
                            SaveProcessedEmailId(emailId);
                        }
                    }
                } else
                {
                    continue;
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred: {ex.Message}");
        }
    }
}



