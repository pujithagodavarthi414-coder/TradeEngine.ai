using BusinessView.Api.Helpers;
using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace BusinessView.Api.Controllers.Api
{
    [Authorize]
    public class EmployeeApiController : ApiController
    {

        private readonly IEmployeeService _employeeService;
        private readonly IJobService _jobService;
        private readonly IEmployeeSalaryService _salaryService;
        private readonly IEmployeeReportService _reportService;
        private readonly IUserService _userService;
        private readonly IBlobService _blobService;
        public EmployeeApiController()
        {
            _blobService = new BlobService();
            _employeeService = new EmployeeService();
            _jobService = new JobService();
            _salaryService = new EmployeeSalaryService();
            _reportService = new EmployeeReportService();
            _userService = new UserService();
        }

        [HttpGet]

        public int CheckExistingUser(string EmployeeId)
        {
            try
            {

               var value =  _employeeService.CheckExistingUser(EmployeeId);
                LoggingManager.Debug("Exiting from Post method of carpet api controller");
                return value;
             
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
                return 0;
               
            }
        }

        public JsonResult<BusinessViewJsonResult> Post()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee api controller");

                int userId = User.Identity.GetUserId<int>();
                
                var model = new EmployeeModel();
                var usermodel = new UsersModel();
                model.FirstName = HttpContext.Current.Request.Form["FirstName"];
                
                model.MiddleName = HttpContext.Current.Request.Form["MiddleName"];
                model.LastName = HttpContext.Current.Request.Form["LastName"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["DateOfBirth"]))
                {
                    var DateOfBirth = HttpContext.Current.Request.Form["DateOfBirth"];
                    model.DateOfBirth = DateTime.ParseExact(DateOfBirth, "dd/MM/yyyy", null);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["LicenceExpiryDate"]))
                {
                    var LicenceExpiryDate = HttpContext.Current.Request.Form["LicenceExpiryDate"];
                    model.LicenceExpiryDate = DateTime.ParseExact(LicenceExpiryDate, "dd/MM/yyyy", null);
                }
              
                model.DriverLicenceNumber = HttpContext.Current.Request.Form["DriverLicenceNumber"];
                model.Gender = HttpContext.Current.Request.Form["Gender"];
                model.NationalityId = Convert.ToInt32(HttpContext.Current.Request.Form["NationalityId"]);             
                model.MartialStatus = HttpContext.Current.Request.Form["MartialStatus"];
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = HttpContext.Current.Request.Form["EmployeeId"];
                }

               model.OtherId = HttpContext.Current.Request.Form["OtherId"];
            
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["UserId"]))
                {
                    model.UserId = Convert.ToInt32(HttpContext.Current.Request.Form["UserId"]);
                }
                if (model.UserId == 0 && !(string.IsNullOrEmpty(model.EmployeeId)))
                {
                    usermodel.UserEmail = HttpContext.Current.Request.Form["UserEmail"];
                    usermodel.Password = HttpContext.Current.Request.Form["Password"];
                    usermodel.RoleId = Convert.ToInt32(HttpContext.Current.Request.Form["RoleId"]);
                    usermodel.BranchId = Convert.ToInt32(HttpContext.Current.Request.Form["BranchId"]);
                    usermodel.IsActive = Convert.ToBoolean(HttpContext.Current.Request.Form["IsActive"]);
                    usermodel.IsAdmin = Convert.ToBoolean(HttpContext.Current.Request.Form["IsAdmin"]);
                    usermodel.UserName = HttpContext.Current.Request.Form["FirstName"];
                    usermodel.SurName = HttpContext.Current.Request.Form["LastName"];
                    Validate(usermodel);
                    if (!ModelState.IsValid)
                    {
                        LoggingManager.Debug("Exiting from Post method of employee api controller");

                        return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                            UiHelper.JsonSerializerSettings);

                    }
                    var newuserId = _userService.AddOrUpdate(usermodel);
                    model.UserId = newuserId;
                }
                var filepath = GetFilePath();
                if (!string.IsNullOrEmpty(filepath))
                {
                    model.PhotoGraph = filepath;
                }
                else
                {
                    model.PhotoGraph = HttpContext.Current.Request.Form["Imagepath"];
                }
            
                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of employee api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);

                    ;
                }

                _employeeService.AddOrUpdate(model);

                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false },
                        UiHelper.JsonSerializerSettings);
            }
        }

        [HttpGet]
        public IList<EmployeesListModel> GetAllEmployees(string employeename, string employeeid, int jobtitleid, int employeestatusid, int subunitid)
        {
            try
            {
                LoggingManager.Debug("Entered into GetAllEmployees method of employee api controller");

                int userId = User.Identity.GetUserId<int>();

                var list = _employeeService.GetAllEmployeesWithFilter(employeename, employeeid, jobtitleid, employeestatusid, subunitid);

                LoggingManager.Debug("Exiting from GetAllEmployees method of employee api controller");

                return list;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }
        }


        private bool IsFileTypeValid(string fileExtension)
        {
            try
            {
                LoggingManager.Info("Entered into IsFileTypeValid method of job api controller");

                string[] validExtensions = { ".jpg", ".gif", ".png" ,".JPG"};

                if (validExtensions.Contains(fileExtension))
                {
                    LoggingManager.Info("Exit from IsFileTypeValid method of job api controller");

                    return true;
                }

                LoggingManager.Info("Exit from IsFileTypeValid method of job api controller");

                return false;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return false;
            }
        }

        private string GetFilePath()
        {
            try
            {
                LoggingManager.Debug("Entered into SaveFile method of employee api controller");

                var userId = User.Identity.GetUserId<int>();

                int count = Convert.ToInt32(HttpContext.Current.Request.Form["Count"]);


                var model = new EmployeeModel();

                var filePath = string.Empty;

                for (int i = 0; i < count; i++)
                {
                    var files = HttpContext.Current.Request.Files["PhotoGraph" + i];

                    if (files != null)
                    {
                        var name = Path.GetFileName(files.FileName);

                        var fileExtension = Path.GetExtension(name);

                        var isValidFile = IsFileTypeValid(fileExtension);

                        if (isValidFile)
                        {
                            filePath = _blobService.UploadFile(files); 
                        }
                    }
                }

                LoggingManager.Debug("Exit from SaveFile method of employee api controller");

                return filePath;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                throw;
            }
        }

        public JsonResult<BusinessViewJsonResult> Uploadattachments()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeAttachmentsmodel();
                var filesize = HttpContext.Current.Request.Form["filesize"];
                var filesizelimit = ConfigurationManager.AppSettings["filesize"];
                decimal newfilesize = Convert.ToInt32(filesizelimit) * 1048576; 
                
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["filesize"]))
                {
                    model.FileSize = Convert.ToDecimal(HttpContext.Current.Request.Form["filesize"]);
                }
                var filepath = GetFilePath();
                if(model.FileSize > newfilesize)
                {
                    return Json(new BusinessViewJsonResult { Success = false },
                   UiHelper.JsonSerializerSettings);
                }
                else
                {
                    model.PhotoGraph = filepath;
                    model.Comments = HttpContext.Current.Request.Form["Comments"];
                    model.FileName = HttpContext.Current.Request.Form["FileName"];

                    model.FileType = HttpContext.Current.Request.Form["FileType"];

                    _employeeService.AddOrUpdateUserAttachments(model, userId);

                    LoggingManager.Debug("Exiting from Post method of carpet api controller");

                    return Json(new BusinessViewJsonResult { Success = true },
                       UiHelper.JsonSerializerSettings);
                }
             

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false },
                        UiHelper.JsonSerializerSettings);
            }
        }

        public JsonResult<BusinessViewJsonResult> UploadUserImage()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeModel();

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
               
                var filepath = GetFilePath();
                model.PhotoGraph = filepath;

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of employee api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }

                _employeeService.AddOrUpdateImagefiles(model);
                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);


            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false },UiHelper.JsonSerializerSettings);
            }
        }
     
        public JsonResult<BusinessViewJsonResult> DeleteUserImage(int id)
        {
            try
            {
               
                _employeeService.DeleteUserImage(id);
                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch(Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false }, UiHelper.JsonSerializerSettings);
            }
        }

        [HttpGet]
        public IList<EmployeeAttachmentsmodel> GetAllEmployeeAttachments(int employeeId,int?Id)
        {
            try
            {
                LoggingManager.Debug("Entered into GetAllEmployeesAttachments method of employee api controller");

                int userId = User.Identity.GetUserId<int>();
                
                var list = _employeeService.GetEmployeeAttachments(employeeId, Id);

                LoggingManager.Debug("Exiting from GetAllEmployeesAttachments method of employee api controller");

                return list;
            }
            catch(Exception exception)
            {
                LoggingManager.Error(exception);

                return null;
            }
        }

        public JsonResult<BusinessViewJsonResult> SaveCommentsOnly(int Id,string comments)
        {
            try
            {
                LoggingManager.Debug("Entered into Save Comments only method of employee api controller");
                _employeeService.UpdateComments(Id, comments);

                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false }, UiHelper.JsonSerializerSettings);
            }
        }

        public JsonResult<BusinessViewJsonResult>DeleteAttachments(int employeeId,int?Id)
        {
            try
            {

                _employeeService.DeleteAttachments(employeeId,Id);
                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public JsonResult<BusinessViewJsonResult> UpdateEmployeeContacts()
        {
            try
            {
                LoggingManager.Debug("Entered into Update Employee Contacts method of employee api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeContact();

                model.Address1 = HttpContext.Current.Request.Form["Address1"];
                model.Address2 = HttpContext.Current.Request.Form["Address2"];
                model.City = HttpContext.Current.Request.Form["City"];
                model.PostalCode = HttpContext.Current.Request.Form["PostalCode"];
                model.Hometelephoneno = HttpContext.Current.Request.Form["Hometelephoneno"];
                model.Mobile = HttpContext.Current.Request.Form["Mobile"];
                model.worktelephoneno = HttpContext.Current.Request.Form["Worktelephoneno"];
                model.Workemail = HttpContext.Current.Request.Form["Workemail"];
                model.Otheremail = HttpContext.Current.Request.Form["Otheremail"];
                model.OtherSpecify = HttpContext.Current.Request.Form["Relationspecify"];
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["StateId"]))
                {     
                    model.StateId = Convert.ToInt32(HttpContext.Current.Request.Form["StateId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["CountryId"]))
                {
                    model.CountryId = Convert.ToInt32(HttpContext.Current.Request.Form["CountryId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["ContactType"]))
                {
                    model.TypeId = Convert.ToInt32(HttpContext.Current.Request.Form["ContactType"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["DateOfBirth"]))
                {
                    var DateOfBirth = HttpContext.Current.Request.Form["DateOfBirth"];
                    model.DateOfBirth = DateTime.ParseExact(DateOfBirth, "dd/MM/yyyy", null);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Name"]))
                {
                    model.Name = HttpContext.Current.Request.Form["Name"];
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Relationship"]))
                {
                    model.Relationship = HttpContext.Current.Request.Form["Relationship"];
                }
                if(model.TypeId ==2  || model.TypeId == 3)
                {
                    Validate(model);

                    if (!ModelState.IsValid)
                    {
                        LoggingManager.Debug("Exiting from Post method of employee api controller");

                        return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                            UiHelper.JsonSerializerSettings);
                    }

                }

                _employeeService.AddOrUpdateContactdetails(model);

                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false }, UiHelper.JsonSerializerSettings);
            }
        }

        public IList<EmployeeContact> GetEmergencyContactdetails(int EmployeeId, int Id)
        {
            using (BViewEntities myFiEntities = new BViewEntities())

            {
                var TypeId = 2;
                return myFiEntities.GetAllEmployeeContacts(EmployeeId, TypeId, Id).Select(x => new EmployeeContact
                {
                    Id = x.Id,
                    EmployeeId = (int)x.EmployeeId,
                    Name = x.Name,
                    Relationship = x.Relationship,
                    Hometelephoneno = x.HomeTelephoneno,
                    Mobile = x.Mobile,
                    worktelephoneno = x.WorkTelephoneno,
                    DateOfBirth = x.DateOfBirth
                }).ToList();
            }
        }

        [HttpDelete]

        public JsonResult<BusinessViewJsonResult> DeleteContacts(int employeeId,int TypeId,int? Id)
        {
            try
            {

                _employeeService.DeleteContacts(employeeId, TypeId,Id);
                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public IList<EmployeeContact> GetDependantContactdetails(int EmployeeId, int Id)
        {
            using (BViewEntities myFiEntities = new BViewEntities())

            {
                var TypeId = 3;
                return myFiEntities.GetAllEmployeeContacts(EmployeeId, TypeId, Id).Select(x => new EmployeeContact
                {
                    Id = x.Id,
                    EmployeeId = (int)x.EmployeeId,
                    Name = x.Name,
                    Relationship = x.Relationship,
                    Hometelephoneno = x.HomeTelephoneno,
                    Mobile = x.Mobile,
                    worktelephoneno = x.WorkTelephoneno,
                    DateOfBirth = x.DateOfBirth
                }).ToList();
            }
        }

        public IList<Immigration> GetImmigrationDetails(int EmployeeId,int Id)
        {
            using (BViewEntities myFiEntities = new BViewEntities())

            {
                
                return myFiEntities.GetEmployeeImmigrationDetails(EmployeeId, Id).Select(x => new Immigration
                {
                    Id = x.Id,
                    EmployeeId = (int)x.EmployeeId,
                    Document = x.Document,
                    DocumentNumber = x.DocumentNumber,
                    CountryName = x.CountryName,
                    IssuedDate = x.IssuedDate,
                    ExpiryDate = x.ExpiryDate,
                    CountryId = (int)x.CountryId,
                    EligibleStatus = x.EligibleStatus,
                    Comments = x.Comments,
                    EligibleReviewDate = x.EligibleReviewDate

                }).ToList();
            }
        }

        public JsonResult<BusinessViewJsonResult> UpdateImmigrationDetails()
        {
            try
            {
                LoggingManager.Debug("Entered into Update Employee Contacts method of employee api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new Immigration();

                model.Document = HttpContext.Current.Request.Form["Document"];
                model.DocumentNumber = HttpContext.Current.Request.Form["Number"];
                model.Comments = HttpContext.Current.Request.Form["Comments"];
                model.EligibleStatus = HttpContext.Current.Request.Form["EligibleStatus"];
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["CountryId"]))
                {
                    model.CountryId = Convert.ToInt32(HttpContext.Current.Request.Form["CountryId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["IssuedDate"]))
                {
                    var Issuedate = HttpContext.Current.Request.Form["IssuedDate"];
                    model.IssuedDate = DateTime.ParseExact(Issuedate, "dd/MM/yyyy", null);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["ExpiryDate"]))
                {
                    var ExpiryDate = HttpContext.Current.Request.Form["ExpiryDate"];
                    model.ExpiryDate = DateTime.ParseExact(ExpiryDate, "dd/MM/yyyy", null);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EligibleReviewDate"]))
                {
                    var Reviewdate = HttpContext.Current.Request.Form["EligibleReviewDate"];
                    model.EligibleReviewDate = DateTime.ParseExact(Reviewdate, "dd/MM/yyyy", null);
                }


                Validate(model);
                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of employee api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }

                _employeeService.AddOrUpdateImmigrationdetails(model);

                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false }, UiHelper.JsonSerializerSettings);
            }
        }

        public JsonResult<BusinessViewJsonResult> DeleteImmigrationDetails(int employeeId,int?Id)
        {
            try
            {

                _employeeService.DeleteImmigrationDetails(employeeId,Id);
                LoggingManager.Debug("Exiting from Post method of DeleteImmigrationDetails of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false }, UiHelper.JsonSerializerSettings);
            }
        }

        public JsonResult<BusinessViewJsonResult> UpdateJobDetails()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new JobModel();
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["JobTitleId"]))
                {
                    model.JobTitleId = Convert.ToInt32(HttpContext.Current.Request.Form["JobTitleId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeStatusId"]))
                {
                    model.EmployeeStatusId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeStatusId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["JobCategoryId"]))
                {
                    model.JobCategoryId = Convert.ToInt32(HttpContext.Current.Request.Form["JobCategoryId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["LocationId"]))
                {
                    model.LocationId = Convert.ToInt32(HttpContext.Current.Request.Form["LocationId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["SubunitId"]))
                {
                    model.SubUnitId = Convert.ToInt32(HttpContext.Current.Request.Form["SubunitId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["JoinedDate"]))
                {
                    var JoinedDate = HttpContext.Current.Request.Form["JoinedDate"];
                    model.JoinedDate = DateTime.ParseExact(JoinedDate, "dd/MM/yyyy", null);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["StartDate"]))
                {
                    var StartDate = HttpContext.Current.Request.Form["StartDate"];
                    model.StartDate = DateTime.ParseExact(StartDate, "dd/MM/yyyy", null);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EndDate"]))
                {
                    var EndDate = HttpContext.Current.Request.Form["EndDate"];
                    model.EndDate = DateTime.ParseExact(EndDate, "dd/MM/yyyy", null);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                var filepath = GetFilePath();
                if (!string.IsNullOrEmpty(filepath))
                {
                    model.Photograph = filepath;
                }
                else
                {
                    model.Photograph = HttpContext.Current.Request.Form["PhotoGraph"];
                }
                 model.ContractDetails = HttpContext.Current.Request.Form["ContractDetails"];

                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of employee api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }
                _jobService.AddOrUpdate(model);

                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false },UiHelper.JsonSerializerSettings);
            }
        }

        [HttpDelete]

        public JsonResult<BusinessViewJsonResult> EmployeeTermination(int employeeId)
        {
            try
            {

                _jobService.TerminateEmployee(employeeId);
                LoggingManager.Debug("Exiting from Post method of DeleteImmigrationDetails of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false },UiHelper.JsonSerializerSettings);
            }
        }

        public IList<EmployeeSalaryModel> GetEmployeeSalaryDetails(int EmployeeId, int Id)
        {
            using (BViewEntities bViewEntities = new BViewEntities())

            {
                return bViewEntities.GetEmployeeSalaryDetails(EmployeeId, Id).Select(x => new EmployeeSalaryModel
                {
                    Id = x.Id,
                    EmployeeId = (int)x.EmployeeId,
                    SalaryComponent = x.SalaryComponent,
                    PayType = x.PayType,
                    PaygradeId = x.PayGradeId,
                    CurrencyName = x.Name,
                    Depositdetails = (bool)x.AddDepositDetails,
                    PayFrequencyId = x.PayFrequencyId,
                    CurrencyId = x.CurrencyId,
                    Amount = x.Amount,
                    AccountNumber = x.AccountNumber,
                    RoutingNumber = x.RoutingNumber,
                    DepositAmount = x.DepositedAmount,
                    Comments = x.Comments,
                    AccountTypeId = x.AccountTypeId,
                    SalaryAccountType = x.SalaryAccountType,
                    TypeName = x.TypeName
                }).ToList();
            }
        }

        public JsonResult<BusinessViewJsonResult> UpdateSalaryDetails()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeSalaryModel();
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["PayGradeId"]))
                {
                    model.PaygradeId = Convert.ToInt32(HttpContext.Current.Request.Form["PayGradeId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["PayFrequencyId"]))
                {
                    model.PayFrequencyId = Convert.ToInt32(HttpContext.Current.Request.Form["PayFrequencyId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["CurrencyId"]))
                {
                    model.CurrencyId = Convert.ToInt32(HttpContext.Current.Request.Form["CurrencyId"]);
                }
               
                    model.SalaryComponent =HttpContext.Current.Request.Form["SalaryComponent"];
                    model.Comments = HttpContext.Current.Request.Form["Comments"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Amount"]))
                {
                    model.Amount = Convert.ToDecimal(HttpContext.Current.Request.Form["Amount"]);
                }
                    
                    model.Depositdetails = Convert.ToBoolean(HttpContext.Current.Request.Form["Depositdetails"]);
                   if(model.Depositdetails == true)
                {
                    model.AccountNumber = HttpContext.Current.Request.Form["AccountNumber"];
                    model.RoutingNumber = HttpContext.Current.Request.Form["RoutingNumber"];
                    model.SalaryAccountType = HttpContext.Current.Request.Form["SalaryAccountType"];
                    model.DepositAmount = Convert.ToDecimal(HttpContext.Current.Request.Form["DepositAmount"]);
                   
                }
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["AccountTypeId"]))
                {
                    model.AccountTypeId = Convert.ToInt32(HttpContext.Current.Request.Form["AccountTypeId"]);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }

                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of employee api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }
                _salaryService.AddOrUpdate(model);

                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false },UiHelper.JsonSerializerSettings);
            }
        }
        [HttpDelete]
        public JsonResult<BusinessViewJsonResult> DeleteEmployeeSalaryDetails(int EmployeeId,int?Id)
        {
            try
            {
                _salaryService.DeleteEmployeeSalary(EmployeeId,Id);
                LoggingManager.Debug("Exiting from Post method of DeleteImmigrationDetails of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false },UiHelper.JsonSerializerSettings);
            }
        }

        public IList<EmployeeReportingModel> GetSupervisorreportdetails(int loggedusername, int Id)
        {
            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var employeedetails = bViewEntities.Employees.FirstOrDefault(x => x.Id == loggedusername).FirstName;
                return bViewEntities.GetAllEmployeeReports(employeedetails, Id).Select(x => new EmployeeReportingModel
                {
                    Id = x.Id,
                    EmployeeId = (int)x.EmployeeId,
                    Name = x.Name,
                    ReportTo = x.Reportto,
                    Comments = x.Comments
                }).ToList();
            }
        }
       
         public IList<EmployeeReportingModel> GetEditedSupervisorreportdetails(int Id)
        {
            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var loggedusername = string.Empty;
               var details =   bViewEntities.GetAllEmployeeReports(loggedusername,Id).Select(x => new EmployeeReportingModel
                {
                    Id = x.Id,
                    EmployeeId = (int)x.EmployeeId,
                    Name = x.Name,
                    ReportTo = x.Reportto,
                    Comments = x.Comments
                }).ToList();

                return details;
            }
        }
        public JsonResult<BusinessViewJsonResult> UpdateEmployeeReports()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeReportingModel();

                model.Name = HttpContext.Current.Request.Form["Name"];
                model.ReportTo = HttpContext.Current.Request.Form["Reportingto"];
                model.Comments = HttpContext.Current.Request.Form["Comments"];
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
               
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }

                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of employee api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }
                _reportService.AddOrUpdate(model);

                LoggingManager.Debug("Exiting from Post method of carpet api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false },UiHelper.JsonSerializerSettings);
            }
        }

        
        public JsonResult<BusinessViewJsonResult> DeleteEmployeeReports(int  EmployeeId,int?Id)
        {
            try
            {

                _reportService.DeleteEmployeeReports(EmployeeId,Id);
                LoggingManager.Debug("Exiting from Post method of DeleteImmigrationDetails of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false }, UiHelper.JsonSerializerSettings);
            }
        }


    }
}
