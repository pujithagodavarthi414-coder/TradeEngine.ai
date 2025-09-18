
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text.RegularExpressions;
using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Notification;
using Btrak.Models.SystemManagement;
using Btrak.Services.Account;
using Btrak.Services.ComplianceAudit;
using Btrak.Services.Email;
using Btrak.Services.MailTemplateActivity;
using Btrak.Services.Notification;
using BTrak.Common;
using BTrak.Common.Constants;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Newtonsoft.Json;
using Unity;


namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("mailtemplate-activity")]
    public class MailTemplateActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                var _mailTemplateService = Unity.UnityContainer.Resolve<MailTemplateActivityService>(); 
                var _mailTemplateRepository = Unity.UnityContainer.Resolve<MailTemplateActivityRepository>();
                var sqlConectionString = (string)externalTask.Variables["sqlConectionString"].Value;
                string message = (string)externalTask.Variables["message"].Value;
                string to = externalTask.Variables.ContainsKey("toUsersString") && externalTask.Variables["toUsersString"]?.Value != null ? Convert.ToString(externalTask.Variables["toUsersString"].Value) : string.Empty;
                string ccEmails =  externalTask.Variables.ContainsKey("ccUsersString") && externalTask.Variables["ccUsersString"]?.Value != null ? Convert.ToString(externalTask.Variables["ccUsersString"].Value) : string.Empty;
                string bccEmails = externalTask.Variables.ContainsKey("bccUsersString") && externalTask.Variables["bccUsersString"]?.Value != null ? Convert.ToString(externalTask.Variables["bccUsersString"].Value) : string.Empty;
                string mailAlertName = (string)externalTask.Variables["name"]?.Value;
                string subject = (string)externalTask.Variables["subject"]?.Value;
                string canSendFormEditLink = (string)externalTask.Variables["isRedirectToEmails"]?.Value;
                string formEditLink = (string)externalTask.Variables["formEditLink"]?.Value;
                string addonToMails = (string)externalTask.Variables["addonToMails"]?.Value;
                var companyId = (string)externalTask.Variables["companyId"].Value;
                var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
                var navigationUrl = (string)externalTask.Variables["navigationUrl"].Value;
                string workflowMessage = (string)externalTask.Variables["workflowMessage"].Value;
                string workflowSubject = (string)externalTask.Variables["workflowSubject"].Value;
                var loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };

                Console.WriteLine("Enter into notification activity and fetching details");
                Console.WriteLine("GetUserDetailsByNameAndCompanyId");
                LoggingManager.Debug("Enter into notification activity and fetching details");
                LoggingManager.Debug("GetUserDetailsByNameAndCompanyId");
                var validationMessages = new List<ValidationMessage>();
                var owner = _mailTemplateRepository.GetUserDetailsByNameAndCompanyId(sqlConectionString,to, new Guid(companyId), validationMessages);
                var companyDetails = _mailTemplateRepository.SearchCompanies(sqlConectionString,new CompanySearchCriteriaInputModel() { CompanyId = new Guid(companyId), ForSuperUser = true }, validationMessages);
                Console.WriteLine(companyDetails);
                if (companyDetails != null)
                {
                    Console.WriteLine(companyDetails);
                    if (companyDetails.Count > 0)
                    {
                        Console.WriteLine(companyDetails[0].CompanyId);
                    }
                }
                Console.WriteLine("to:" + to.ToString());
                Console.WriteLine("companyId:" + companyId?.ToString());
                Console.WriteLine("loggedUserId:" + loggedUserId?.ToString());
                LoggingManager.Debug("to:" + to.ToString());
                LoggingManager.Debug("companyId:" + companyId?.ToString());
                LoggingManager.Debug("loggedUserId:" + loggedUserId?.ToString());
                Guid ownerId = Guid.Empty;
                LoggingManager.Debug("Fetched owner");
                if (owner != null)
                {
                    LoggingManager.Debug("owner is null");
                    ownerId = owner.Id;
                }
                LoggingManager.Debug("owner:" + owner?.ToString());
                LoggingManager.Debug("ownerId:" + ownerId.ToString());

                Console.WriteLine("Getting smtp details");
                SmtpDetailsModel smtpDetails = _mailTemplateRepository.SearchSmtpCredentials(sqlConectionString,loggedInContext, new List<ValidationMessage>(), null);
                Console.WriteLine("smtpDetails : " + smtpDetails.ToString());
                var companyName = string.Empty;
                if (companyDetails != null && companyDetails.Count > 0) { companyName = companyDetails[0].CompanyName; } else { companyName = "NxusWorld"; }

                /* Form Edit Link Format : forms/submit-form/:formId/:customapplicationId/:submittedId */
                bool isRedirectEmail = Convert.ToBoolean(canSendFormEditLink);
                if(!string.IsNullOrEmpty(workflowSubject))
                {
                    subject = workflowSubject;
                }
                if (!string.IsNullOrEmpty(workflowMessage))
                {
                    message = workflowMessage;
                }
                if (isRedirectEmail)
                {
                    string emailBody = $@"<!DOCTYPE html>
                                        <html lang=""en"">
                                        
                                        <body>
                                            <a href=""{formEditLink}"" target=""_blank"">Click here</a>
                                        </body>
                                        </html>";
                    message = message + "</br/>" + emailBody;
                }

                string[] toMails = to.Split(',');
                string[] ccMails = ccEmails.Split(',');
                string[] bccMails = bccEmails.Split(',');

                

                //To replace dynamic button urls in webview 
                if (!string.IsNullOrWhiteSpace(navigationUrl))
                {
                    Console.WriteLine("navigationUrl:" + navigationUrl.ToString());
                    Console.WriteLine("Entered to replace dynamic button urls in webview");
                    // Deserialize JSON string to C# object
                    NavigationUrlModel customNavigation = JsonConvert.DeserializeObject<NavigationUrlModel>(navigationUrl);
                    Console.WriteLine("navigationUrl:" + navigationUrl.ToString());
                    if (customNavigation != null)
                    {
                        string pattern = @"href=""(.*?)""";
                        Console.WriteLine("ButtonName:" + customNavigation.ButtonName);
                        Console.WriteLine("BtnNavigationUrl:" + customNavigation.BtnNavigationUrl);
                        if (message.Contains('#' + customNavigation.ButtonName))
                        {
                            string replacedHtml = Regex.Replace(message, pattern, match =>
                            {
                                string url = match.Groups[1].Value;
                                if (url.Contains('#' + customNavigation.ButtonName))
                                {
                                    return $"href=\"{customNavigation.BtnNavigationUrl}\"";
                                }
                                else
                                {
                                    return match.Value;
                                }
                            });
                            if (!string.IsNullOrWhiteSpace(replacedHtml))
                            {
                                message = replacedHtml;
                            }
                        }
                        else
                        {
                            string emailBody = $@"<!DOCTYPE html>
                                        <html lang=""en"">
                                        
                                        <body>
                                            <a href=""{customNavigation.BtnNavigationUrl}"" target=""_blank"">{customNavigation.ButtonName}</a>
                                        </body>
                                        </html>";
                            message = message + "</br/>" + emailBody;

                        }
                    }
                    Console.WriteLine("Exited from replacing dynamic button urls in webview");
                }

                if (!string.IsNullOrWhiteSpace(addonToMails))
                {
                    List<string> addonToMailList = addonToMails.Split(',').ToList();
                    addonToMailList.AddRange(toMails);
                    toMails = addonToMailList.ToArray();
                }

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = toMails,
                        HtmlContent = message,
                        Subject = subject,
                        CCMails = ccMails,
                        BCCMails = bccMails,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    Console.WriteLine("smtpmail" + smtpDetails?.SmtpMail);
                    _mailTemplateService.SendMail(sqlConectionString, loggedInContext, emailModel);
                    Console.WriteLine("After sendMail");
                });
            }

            catch (Exception ex)
            {
                LoggingManager.Debug("Exception" + ex);
                Console.WriteLine(ex);
            }
        }

    }
}
