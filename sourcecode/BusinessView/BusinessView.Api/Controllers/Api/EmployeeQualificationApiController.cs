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
    public class EmployeeQualificationApiController : ApiController
    {
        private readonly IEmployeeQualificationService _qualificationService;
        private readonly IEMembershipService _membershipservice;

        public EmployeeQualificationApiController()
        {
            _qualificationService = new EmployeeQualificationService();
            _membershipservice = new MembershipService();
        }

        public IList<EmployeeQualificationModel> GetWorkExperiencedetails(int EmployeeId, int Id)
        {
            using (BViewEntities myFiEntities = new BViewEntities())

            {

                return myFiEntities.GetEmployeeExperienceDetails(EmployeeId, Id).Select(x => new EmployeeQualificationModel
                {
                    Id = x.Id,
                    EmployeeId = Convert.ToInt32(x.EmployeeId),
                    Company = x.Company,
                    JobTitle = x.JobTitle,
                    Comments = x.Comments,
                    FromDate = x.FromDate,
                    ToDate = x.ToDate
                }).ToList();
            }
        }

        public JsonResult<BusinessViewJsonResult> UpdateWorkExperience()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee qualification  api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeQualificationModel();
              
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                model.Company = HttpContext.Current.Request.Form["Company"];
                model.JobTitle = HttpContext.Current.Request.Form["JobTitle"];
                model.Comments = HttpContext.Current.Request.Form["Comments"];
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["FromDate"]))
                {
                    var FromDate = HttpContext.Current.Request.Form["FromDate"];
                    model.FromDate = DateTime.ParseExact(FromDate, "dd/MM/yyyy", null);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["ToDate"]))
                {
                    var ToDate = HttpContext.Current.Request.Form["ToDate"];
                    model.ToDate = DateTime.ParseExact(ToDate, "dd/MM/yyyy", null);
                }
                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of qualification api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }
                _qualificationService.AddOrUpdate(model);

                LoggingManager.Debug("Exiting from Post method of qualification api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public JsonResult<BusinessViewJsonResult> DeleteWorkExperience(int EmployeeId,int?Id)
        {
            try
            {

                _qualificationService.DeleteWorkExperiencedetails(EmployeeId,Id);
                LoggingManager.Debug("Exiting from Post method of Delete Work Experience of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public IList<EmployeeQualificationModel> GetEducationDetails(int EmployeeId, int Id)
        {
            using (BViewEntities myFiEntities = new BViewEntities())

            {

                return myFiEntities.GetEmployeeEducationDetails(EmployeeId, Id).Select(x => new EmployeeQualificationModel
                {
                    Id = x.Id,
                    EmployeeId = Convert.ToInt32(x.EmployeeId),
                    LevelId = (int)x.LevelId,
                    LevelName = x.Level,
                    Specialization = x.MajorSpecilalization,
                    Year = x.Year,
                    Percentage = (decimal)x.Score,
                  
                }).ToList();
            }
        }


        public JsonResult<BusinessViewJsonResult> UpdateEducationDetails()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee education  api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeEducationModel();

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["LevelId"]))
                {
                    model.LevelId = Convert.ToInt32(HttpContext.Current.Request.Form["LevelId"]);
                }
                model.Institute = HttpContext.Current.Request.Form["Institute"];
                model.Specialization = HttpContext.Current.Request.Form["Specialization"];
                model.Year = HttpContext.Current.Request.Form["Year"];
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Percentage"]))
                {
                    model.Percentage = Convert.ToDecimal(HttpContext.Current.Request.Form["Percentage"]);
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

                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of qualification api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }
                _qualificationService.AddOrUpdateEducationdetails(model);

                LoggingManager.Debug("Exiting from Post method of qualification api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public JsonResult<BusinessViewJsonResult> DeleteEducationDetails(int EmployeeId,int?Id)
        {
            try
            {

                _qualificationService.DeleteEducationDetails(EmployeeId,Id);
                LoggingManager.Debug("Exiting from Post method of Delete Education Details of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public IList<EmployeeSkillModel> GetSkillDetails(int EmployeeId, int Id)
        {
            using (BViewEntities myFiEntities = new BViewEntities())

            {

                return myFiEntities.GetEmployeeSkillDetails(EmployeeId, Id).Select(x => new EmployeeSkillModel
                {
                    Id = x.Id,
                    EmployeeId = Convert.ToInt32(x.EmployeeId),
                    SkillId = (int)x.SkillId,
                    Experience = x.YearsOfExprience,
                    Comments = x.Comments,
                    SkillName = x.Name
                }).ToList();
            }
        }

        public JsonResult<BusinessViewJsonResult> UpdateSkillDetails()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee qualification  api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeSkillModel();

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                model.SkillId = Convert.ToInt32(HttpContext.Current.Request.Form["SkillId"]);
                model.Experience = HttpContext.Current.Request.Form["Experience"];
                model.Comments = HttpContext.Current.Request.Form["Comments"];
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of employee api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }
                _qualificationService.AddOrUpdateSkillDetails(model);

                LoggingManager.Debug("Exiting from Post method of qualification api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public JsonResult<BusinessViewJsonResult> DeleteSkillDetails(int EmployeeId,int ?Id)
        {
            try
            {

                _qualificationService.DeleteSkillDetails(EmployeeId,Id);
                LoggingManager.Debug("Exiting from Post method of Delete Employee Skill details of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public IList<EmployeeQualificationModel> GetLanguageDetails(int EmployeeId, int Id)
        {
            using (BViewEntities myFiEntities = new BViewEntities())
            {
                return myFiEntities.GetEmployeeLanguageDetails(EmployeeId,Id).Select(x => new EmployeeQualificationModel
                {
                    Id = x.Id,
                    EmployeeId = Convert.ToInt32(x.EmployeeId),
                    LanguageId = (int)x.LanguageId,
                    LangauageName = x.Name,
                    FluencyId = (int)x.FluencyId,
                    FluencyName = x.FluencyName,
                    CompetencyId = (int)x.CompetencyId,
                    CompetencyName = x.CompetencyName,
                    Comments = x.Comments
                }).ToList();
            }
        }

        public JsonResult<BusinessViewJsonResult> UpdateLanguagedetails()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee qualification  api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeLanguageModel();

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["LanguageId"]))
                {
                    model.LanguageId = Convert.ToInt32(HttpContext.Current.Request.Form["LanguageId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["FluencyId"]))
                {
                    model.FluencyId = Convert.ToInt32(HttpContext.Current.Request.Form["FluencyId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["CompetencyId"]))
                {
                    model.CompetencyId = Convert.ToInt32(HttpContext.Current.Request.Form["CompetencyId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                model.Comments = HttpContext.Current.Request.Form["Comments"];
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of employee api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }
                _qualificationService.AddOrUpdateLanguageDetails(model);

                LoggingManager.Debug("Exiting from Post method of qualification api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public JsonResult<BusinessViewJsonResult> DeleteLanguagedetails(int EmployeeId,int?Id)
        {
            try
            {

                _qualificationService.DeleteLanguageDetails(EmployeeId,Id);
                LoggingManager.Debug("Exiting from Post method of Delete Employee language details of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public IList<EmployeeQualificationModel> GetLicencedetails(int EmployeeId, int Id)
        {
            using (BViewEntities myFiEntities = new BViewEntities())
            {
                return myFiEntities.GetEmployeeLicenceDetails(EmployeeId, Id).Select(x => new EmployeeQualificationModel
                {
                    Id = x.Id,
                    EmployeeId = Convert.ToInt32(x.EmployeeId),
                    LicenceTypeId = (int)x.LicenceTypeId,
                    LicenceTypeName = x.Name,
                    LicenceNumber = x.LicenceNumber,
                    IssuedDate = x.IssuedDate,
                    ExpiryDate = x.ExpiryDate
                }).ToList();
            }
        }

        public JsonResult<BusinessViewJsonResult> UpdateLicenecDetails()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee qualification  api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeLicenceModel();

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["LicenceTypeId"]))
                {
                    model.LicenceTypeId = Convert.ToInt32(HttpContext.Current.Request.Form["LicenceTypeId"]);
                }
                model.LicenceNumber = HttpContext.Current.Request.Form["LicenceNumber"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["IssuedDate"]))
                {
                    var IssuedDate = HttpContext.Current.Request.Form["IssuedDate"];
                    model.IssuedDate = DateTime.ParseExact(IssuedDate, "dd/MM/yyyy", null);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["ExpiryDate"]))
                {
                    var ExpiryDate = HttpContext.Current.Request.Form["ExpiryDate"];
                    model.ExpiryDate = DateTime.ParseExact(ExpiryDate, "dd/MM/yyyy", null);
                }
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of employee api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }
                _qualificationService.AddOrUpdateLicenceDetails(model);

                LoggingManager.Debug("Exiting from Post method of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public JsonResult<BusinessViewJsonResult> DeleteLicenceDetails(int EmployeeId,int ?Id)
        {
            try
            {

                _qualificationService.DeleteLicenceDetails(EmployeeId,Id);
                LoggingManager.Debug("Exiting from Post method of delete licence details of  api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public IList<EmployeeMembershipModel> GetMembershipDetails(int EmployeeId, int Id)
        {
            using (BViewEntities myFiEntities = new BViewEntities())

            {

                return myFiEntities.GetEmployeeMembershipDetails(EmployeeId, Id).Select(x => new EmployeeMembershipModel
                {
                    Id = x.Id,
                    EmployeeId = (int)x.EmployeeId,
                    MembershipId = (int)x.MembershipId,
                    MembershipName = x.Name,
                    Subscription = x.Subscription,
                    SubscriptionAmount = x.SubscriptionAmount,
                    CurrencyId = (int)x.CurrencyId,
                    CurrencyName = x.CurrencyName,
                    CommenceDate = x.CommenceDate,
                    RenewalDate = x.RenewalDate
                }).ToList();
            }
        }

        public JsonResult<BusinessViewJsonResult> UpdateMembershipDetails()
        {
            try
            {
                LoggingManager.Debug("Entered into Post method of employee qualification  api controller");

                int userId = User.Identity.GetUserId<int>();

                var model = new EmployeeMembershipModel();

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["EmployeeId"]))
                {
                    model.EmployeeId = Convert.ToInt32(HttpContext.Current.Request.Form["EmployeeId"]);
                }

                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["Id"]))
                {
                    model.Id = Convert.ToInt32(HttpContext.Current.Request.Form["Id"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["MembershipId"]))
                {
                    model.MembershipId = Convert.ToInt32(HttpContext.Current.Request.Form["MembershipId"]);
                }
                model.Subscription = HttpContext.Current.Request.Form["Subscription"];
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["SubscriptionAmount"]))
                {
                    model.SubscriptionAmount = Convert.ToDecimal(HttpContext.Current.Request.Form["SubscriptionAmount"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["CurrencyId"]))
                {
                    model.CurrencyId = Convert.ToInt32(HttpContext.Current.Request.Form["CurrencyId"]);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["CommenceDate"]))
                {
                    var CommenceDate = HttpContext.Current.Request.Form["CommenceDate"];
                    model.CommenceDate = DateTime.ParseExact(CommenceDate, "dd/MM/yyyy", null);
                }
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["RenewalDate"]))
                {
                    var RenewalDate = HttpContext.Current.Request.Form["RenewalDate"];
                    model.RenewalDate = DateTime.ParseExact(RenewalDate, "dd/MM/yyyy", null);
                }
                model.loggedusername = HttpContext.Current.Request.Form["loggedusername"];
                Validate(model);

                if (!ModelState.IsValid)
                {
                    LoggingManager.Debug("Exiting from Post method of qualification api controller");

                    return Json(new BusinessViewJsonResult { Success = false, ModelState = ModelState },
                        UiHelper.JsonSerializerSettings);
                }
                _membershipservice.AddOrUpdate(model);

                LoggingManager.Debug("Exiting from Post method of qualification api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

        public JsonResult<BusinessViewJsonResult> DeleteMembership(int EmployeeId,int ?Id)
        {
            try
            {

                _membershipservice.DeleteMembershipDetails(EmployeeId,Id);
                LoggingManager.Debug("Exiting from Post method of Delete membership details of qualification api controller");

                return Json(new BusinessViewJsonResult { Success = true },
                   UiHelper.JsonSerializerSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                return Json(new BusinessViewJsonResult { Success = false });
            }
        }

    }
}
