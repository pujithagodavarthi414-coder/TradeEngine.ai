using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Web.Http;
using Btrak.Models.EmailTemplates;
using BTrak.Api.Controllers.Api;
using BTrak.Common;
using Dapper;

namespace BTrak.Api.Controllers.EmailTemplates
{
    public class EmailTemplateController : AuthTokenApiController
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString;

        [HttpGet]
        [HttpOptions]
        [Route("EmailTemplate/EmailTemplateApi/GetTemplateList")]
        public List<EmailTemplatesToTable> GetTemplateList()
        {
            try
            {
                var query = "select * from Template where IsDeleted = 'false' ";

                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var templates = db.Query<EmailTemplatesToTable>(query).ToList();

                    foreach (var template in templates)
                    {
                        template.CreatedDate = template.CreatedDateTime?.ToString("dd-MMM-yyyy");
                        template.TemplateType = db.Query<string>("select TemplateTypeName from TemplateType where Id ='" + template.TemplateTypeId + "'").FirstOrDefault();
                    }
                    return templates.ToList();
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTemplateList", "EmailTemplateController", exception.Message), exception);

                return null;
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route("EmailTemplate/EmailTemplateApi/GetTemplateTypeList")]
        public List<TemplateType> GetTemplateTypeList()
        {
            try
            {
                var query = "select t.Id as Id,tty.TemplateTypeName as TemplateTypeName from TemplateType tty join Template t on tty.Id = t.TemplateTypeId where t.IsDeleted = 'false'";
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var templatesTypes = db.Query<TemplateType>(query);
                    return templatesTypes.ToList();
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTemplateTypeList", "EmailTemplateController", exception.Message), exception);

                return null;
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route("EmailTemplate/EmailTemplateApi/GetEmployeeList")]
        public List<EmployeeList> GetEmployeeList()
        {
            try
            {
                var query = "select Id,FirstName as EmployeeName from [User]";
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var employeeNames = db.Query<EmployeeList>(query);
                    return employeeNames.ToList();
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeList", "EmailTemplateController", exception.Message), exception);

                return new List<EmployeeList>();
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route("EmailTemplate/EmailTemplateApi/OfferTemplateModel")]
        public OfferTemplateModel OfferTemplateModel(string name)
        {
            try
            {
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var userId = db.Query<Guid>("select Id from [User] where FirstName = '" + name + "'").FirstOrDefault();
                    var employeeId = db.Query<Guid>("select Id from Employee where userId = '" + userId + "'").FirstOrDefault();
                    //var query = "select * from OfferLetterTemplate where EmployeeId ='" + employeeId + "'";
                    var query = "select ecd.Address1 as address, ecd.Mobile as phone, d.Designation as jobTitle , es.Amount as salary from EmployeeContactDetails ecd " +
                                "join EmployeeDesignation ed on	ecd.EmployeeId = ed.EmployeeId " +
                                "join Designation d on d.Id = ed.DesignationId " +
                                "join EmployeeSalary es on ecd.EmployeeId = es.EmployeeId " +
                                "where ecd.EmployeeId = '" + employeeId + "'";
                    var record = db.Query<OfferTemplateModel>(query).FirstOrDefault();
                    if (record != null)
                    {
                        record.EmployeeName = name;
                        record.ReportDate = record.ReportDateTime.ToString("dd-MMM-yyyy");
                        record.CurrentDate = DateTime.Now.ToString("dd/mm/yyyy");
                    }
                    return record;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "OfferTemplateModel", "EmailTemplateController", exception.Message), exception);

                return null;
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route("EmailTemplate/EmailTemplateApi/GetTemplate")]
        public TemplateModel GetTemplate(string templateId)
        {
            try
            {
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var query = "select * from Template where Id = '" + templateId + "'";
                    var template = db.Query<TemplateModel>(query).FirstOrDefault();
                    if (template != null)
                    {
                        string templatename = db.Query<string>("select TemplateTypeName from TemplateType where  Id = '" +
                                                               template.TemplateTypeId + "'").FirstOrDefault();
                        template.TemplateType = templatename;
                    }
                    return template;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTemplate", "EmailTemplateController", exception.Message), exception);

                return null;
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route("EmailTemplate/EmailTemplateApi/GetTemplateContent")]
        public string GetTemplateContent(string EmployeeId, string TemplateId)
        {
            try
            {
                OfferTemplateModel offerTemplateModel;
                TemplateModel template;
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var name = db.Query<string>("select FirstName from [User] where Id = '" + EmployeeId + "'").FirstOrDefault();
                    var employeeId = db.Query<Guid>("select Id from Employee where userId = '" + EmployeeId + "'").FirstOrDefault();
                    //var query = "select * from OfferLetterTemplate where EmployeeId ='" + employeeId + "'";
                    var query = "select ecd.Address1 as address, ecd.Mobile as phone, d.Designation as jobTitle , es.Amount as salary from EmployeeContactDetails ecd " +
                                "join EmployeeDesignation ed on	ecd.EmployeeId = ed.EmployeeId " +
                                "join Designation d on d.Id = ed.DesignationId " +
                                "join EmployeeSalary es on ecd.EmployeeId = es.EmployeeId " +
                                "where ecd.EmployeeId = '" + employeeId + "'";
                    offerTemplateModel = db.Query<OfferTemplateModel>(query).FirstOrDefault();
                    if (offerTemplateModel != null)
                    {
                        offerTemplateModel.EmployeeName = name;
                        offerTemplateModel.ReportDate = offerTemplateModel.ReportDateTime.ToString("dd-MMM-yyyy");
                        offerTemplateModel.CurrentDate = DateTime.Now.ToString("dd/mm/yyyy");
                    }
                }
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var query = "select * from Template where Id = '" + TemplateId + "'";
                    template = db.Query<TemplateModel>(query).FirstOrDefault();
                    if (template != null)
                    {
                        string templatename = db.Query<string>("select TemplateTypeName from TemplateType where  Id = '" +
                                                               template.TemplateTypeId + "'").FirstOrDefault();
                        template.TemplateType = templatename;
                    }
                }

                if (template != null)
                {
                    string templateDescription = template.TemplateDescription;
                    templateDescription = templateDescription.Replace("##CurrentDate##", offerTemplateModel.CurrentDate);
                    templateDescription = templateDescription.Replace("##Employee##", offerTemplateModel.EmployeeName);
                    templateDescription = templateDescription.Replace("##Address##", offerTemplateModel.Address);
                    templateDescription = templateDescription.Replace("##Phone##", offerTemplateModel.Phone);
                    templateDescription = templateDescription.Replace("##JobTitle##", offerTemplateModel.JobTitle);
                    templateDescription = templateDescription.Replace("##PackageInWords##", offerTemplateModel.PackageInWords);
                    templateDescription = templateDescription.Replace("##PackageInLakhs##", offerTemplateModel.PackageInLakhs.ToString());
                    templateDescription = templateDescription.Replace("##SpecialAllowance##", offerTemplateModel.SpecialAllowance.ToString());
                    templateDescription = templateDescription.Replace("##ReportDate##", offerTemplateModel.ReportDate);
                    templateDescription = templateDescription.Replace("##Basic##", offerTemplateModel.BasicSalary.ToString());
                    templateDescription = templateDescription.Replace("##HRA##", offerTemplateModel.HRA.ToString());
                    templateDescription = templateDescription.Replace("##ConveyanceAllowance##", offerTemplateModel.ConveyanceAllowance.ToString());
                    templateDescription = templateDescription.Replace("##MedicalAllowance##", offerTemplateModel.MedicalAllowance.ToString());
                    templateDescription = templateDescription.Replace("##YearlyBonus##", offerTemplateModel.YearlyBonus.ToString());
                    templateDescription = templateDescription.Replace("##GrossSalary##", offerTemplateModel.GrossSalary.ToString());
                    templateDescription = templateDescription.Replace("##EmployerPF##", offerTemplateModel.EmployerPF.ToString());
                    templateDescription = templateDescription.Replace("##CTC##", offerTemplateModel.CTC.ToString());
                    return templateDescription;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTemplateContent", "EmailTemplateController", exception.Message), exception);

                return null;
            }

            return null;
        }

        [HttpPost]
        [HttpOptions]
        [Route("EmailTemplate/EmailTemplateApi/AddOrUpdateTemplate")]
        public bool AddOrUpdateTemplate([FromBody]TemplateModel template)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DynamicParameters param = new DynamicParameters();
                    DynamicParameters templateTypeParams = new DynamicParameters();
                    if (template.Id == Guid.Empty)
                    {
                        template.Id = Guid.NewGuid();
                        template.TemplateTypeId = Guid.NewGuid();
                        template.IsDeleted = false;
                        template.CreatedDateTime = DateTime.Now;
                        template.UpdatedDateTime = null;

                        templateTypeParams.Add("@Id", template.TemplateTypeId);
                        templateTypeParams.Add("@TemplateTypeName", template.TemplateType);
                        templateTypeParams.Add("@CreatedDateTime", DateTime.Now);
                        templateTypeParams.Add("@CreatedByUserId", template.CreatedByUserId);
                        templateTypeParams.Add("@UpdatedDateTime", DateTime.Now);
                        templateTypeParams.Add("@UpdatedByUserId", template.CreatedByUserId);

                        param.Add("@Id", template.Id);
                        param.Add("@TemplateTypeId", template.TemplateTypeId);
                        param.Add("@TemplateDescription", template.TemplateDescription);
                        param.Add("@IsDeleted", false);
                        param.Add("@CreatedDateTime", DateTime.Now);
                        param.Add("@CreatedByUserId", template.CreatedByUserId);
                        param.Add("@UpdatedDateTime", DateTime.Now);
                        param.Add("@UpdatedByUserId", template.CreatedByUserId);

                        using (IDbConnection db = new SqlConnection(connectionString))
                        {
                            db.Execute("USP_TemplateTypeInsert", templateTypeParams, commandType: CommandType.StoredProcedure);
                            db.Execute("USP_TemplateInsert", param, commandType: CommandType.StoredProcedure);
                        }
                    }
                    else
                    {
                        param.Add("@Id", template.Id);
                        param.Add("@TemplateDescription", template.TemplateDescription);
                        param.Add("@UpdatedDateTime", DateTime.Now);
                        param.Add("@UpdatedByUserId", template.UpdatedByUserId);
                        param.Add("@TemplateTypeName", template.TemplateType);
                        using (IDbConnection db = new SqlConnection(connectionString))
                        {
                            db.Execute("USP_TemplateUpdate", param, commandType: CommandType.StoredProcedure);
                        }
                    }
                    return ModelState.IsValid;
                }
                else
                {
                    return ModelState.IsValid;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddOrUpdateTemplate", "EmailTemplateController", exception.Message), exception);

                return false;
            }
        }

        [HttpDelete]
        [HttpOptions]
        [Route("EmailTemplate/EmailTemplateApi/DeleteTemplate")]
        public string DeleteTemplate(Guid templateId)
        {
            try
            {
                if (templateId != null || templateId != Guid.Empty)
                {
                    DynamicParameters param = new DynamicParameters();
                    param.Add("@Id", templateId);
                    param.Add("@IsDeleted", true);
                    param.Add("@UpdatedDateTime", DateTime.Now);
                    param.Add("@UpdatedByUserId", null);

                    using (IDbConnection db = new SqlConnection(connectionString))
                    {
                        db.Execute("USP_TemplateDelete", param, commandType: CommandType.StoredProcedure);
                    }
                    return "deleted Successfully";
                }
                else
                {
                    return "templateId Should not be null or empty";
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTemplate", "EmailTemplateController", exception.Message), exception);

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route("EmailTemplate/EmailTemplateApi/SendMail")]
        public string SendMail([FromBody]TemplateModel templatesModel, string user)
        {
            try
            {
                string to;
                string response;
                if (ModelState.IsValid)
                {
                    using (IDbConnection db = new SqlConnection(connectionString))
                    {
                        var query = "select UserName from [User] where Id ='" + user + "'";
                        to = db.Query<string>(query).FirstOrDefault();
                    }
                    response = SendMail(to, templatesModel.TemplateType, templatesModel.TemplateDescription);
                }
                else
                {
                    return "Email Sent is not valid";
                }
                return response;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMail", "EmailTemplateController", exception.Message), exception);

                return null;
            }
        }

        private string SendMail(string to, string subject, string content)
        {
            try
            {
                var fromAddress = new MailAddress("");
                var fromPassword = "";
                var toAddress = new MailAddress("");
                //var toAddress = new MailAddress(to);
                // string subject = "testing templates";
                string body = content;
                body = "<html><body>" + body + "</body></html>";
                ContentType contentType = new ContentType();
                contentType.MediaType = "text/html";
                contentType.Name = "samplewordfile.docx";
                Attachment attachment = new Attachment(new MemoryStream(Encoding.Default.GetBytes(body)), contentType);

                SmtpClient smtp = new SmtpClient
                {
                    Host = "smtp.gmail.com",
                    Port = 587,
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
                };
                using (var message = new System.Net.Mail.MailMessage(fromAddress, toAddress)
                {
                    Subject = subject,
                    //Body = body,
                    //IsBodyHtml = true,
                })
                {
                    message.Attachments.Add(attachment);
                    smtp.Send(message);
                }
                return "Succesfull";
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMail", "EmailTemplateController", exception.Message), exception);

                return "An exception occured while sending an email";
            }
        }
    }
}