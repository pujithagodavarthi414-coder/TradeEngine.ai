using Btrak.Models;
using Btrak.Services.ProjectFeature;
using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;

namespace BTrak.Api.Controllers.ProjectFeature
{
    public class ProjectFeatureApiController : AuthTokenApiController
    {
        private readonly IProjectFeatureService _projectFeatureService;

        public ProjectFeatureApiController()
        {
            _projectFeatureService = new ProjectFeatureService();
        }

        [HttpGet]
        [HttpOptions]
        [Route("ProjectFeature/ProjectFeatureApi/GetAllFeatureResposiblePersons")]
        public List<ProjectFeatureModel> GetAllFeatureResposiblePersons(Guid projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Feature Resposible Persons", "Project Feature Api"));
                return _projectFeatureService.GetAllFeatureResposiblePersons(projectId,LoggedInContext);
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Feature Resposible Persons", "Project Feature Api", exception));
                throw;
            }

        }

        [HttpGet]
        [HttpOptions]
        [Route("ProjectFeature/ProjectFeatureApi/GetProjectFeatureDetails")]
        public string GetProjectFeatureDetails(Guid id, Guid projectId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Project Feature Details", "Project Feature Api"));
            var result = _projectFeatureService.GetProjectFeatureDetails(id, projectId, LoggedInContext);
            return JsonConvert.SerializeObject(result);
        }

        [HttpGet]
        [HttpOptions]
        [Route("ProjectFeature/ProjectFeatureApi/AutoCompleteFeatures")]
        public List<FeatureList> AutoCompleteFeatures(string featureName)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Auto Complete Features", "Project Feature Api"));

            return _projectFeatureService.AutoCompleteFeatures(featureName);
        }

        [HttpGet]
        [HttpOptions]
        [Route("ProjectFeature/ProjectFeatureApi/GetProjectFeaturesList")]
        public List<FeatureList> GetProjectFeaturesList(Guid projectId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Project Features List", "Project Feature Api"));

            return _projectFeatureService.ProjectFeatures(projectId);
        }

        [HttpGet]
        [HttpOptions]
        [Route("ProjectFeature/ProjectFeatureApi/AddNewFeature")]
        public JsonResult<BtrakJsonResult> AddNewFeature(Guid projectId,Guid userId, string feature)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Feature", "Project Feature Api"));

                if (feature != null)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Feature", "Project Feature Api"));

                    bool result = _projectFeatureService.AddFeature(userId, feature.Trim(), projectId, LoggedInContext);

                    if (result)
                        return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    return Json(new BtrakJsonResult("This feature already exist."), UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                return Json(new BtrakJsonResult("Please Enter Feature"), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Add Feature", "Project Feature Api", exception));

                throw;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route("ProjectFeature/ProjectFeatureApi/AddProjectFeature")]
        public JsonResult<BtrakJsonResult> AddProjectFeature(Guid userId, Guid featureId, string feature, Guid projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Project Feature", "Project Feature Api"));

               if (featureId != Guid.Empty && userId != Guid.Empty && feature != null)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Project Feature", "Project Feature Api"));

                    bool result = _projectFeatureService.AddProjectFeature(userId, featureId, feature.Trim(), projectId,
                        LoggedInContext);

                    if (result)
                        return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);

                    return Json(new BtrakJsonResult("Record insert/update in server failed "), UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                if (feature == null)
                    return Json(new BtrakJsonResult("Please Enter Feature"), UiHelper.JsonSerializerNullValueIncludeSettings);
                if (userId == Guid.Empty)
                    return Json(new BtrakJsonResult("Please Select Responsible Person"), UiHelper.JsonSerializerNullValueIncludeSettings);

                return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Add Project Feature", "Project Feature Api", exception));

                throw;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route("ProjectFeature/ProjectFeatureApi/DetleteFeatureDetails")]
        public bool DetleteFeatureDetails(Guid featureId, Guid projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Detlete Feature Details", "Project Feature Api"));

                return _projectFeatureService.DetleteFeatureDetails(featureId, projectId,LoggedInContext);
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Detlete Feature Details", "Project Feature Api", exception));
                throw;
            }

        }
    }
}
