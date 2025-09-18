
using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class RolesApiController : ApiController
    {
        private readonly IRoleService _roleService;
        private readonly IAuditService _auditService;

        public RolesApiController()
        {
            _roleService = new RoleService();
            _auditService = new AuditService();
        }

        [HttpPut]
        public string UpdateFeatures(RolesModel model)
        {
            using (var entities = new BViewEntities())
            {
                int roleId = _roleService.AddOrUpdateRole(model);

                var existedFeatureIds = entities.PermissionsBasedOnRoles.Where(x => x.RoleId == model.Id)?.Select(x => (int)x.FeatureId).ToList();
                var selectedFeatureIds = model.FeatureIds.ToList();

                var addFeatureIds = selectedFeatureIds.Except(existedFeatureIds);
                foreach (var featureId in addFeatureIds)
                {
                    var permission = new PermissionsBasedOnRole
                    {
                        RoleId = model.Id,
                        FeatureId = featureId
                    };

                    entities.PermissionsBasedOnRoles.Add(permission);
                    entities.SaveChanges();
                }

                var deleteFeatureIds = existedFeatureIds.Except(selectedFeatureIds);
                foreach (var featureId in deleteFeatureIds)
                {
                    var permission = entities.PermissionsBasedOnRoles.FirstOrDefault(x => x.RoleId == model.Id && x.FeatureId == featureId);

                    if (permission != null)
                    {
                        entities.PermissionsBasedOnRoles.Remove(permission);
                        entities.SaveChanges();
                    }
                }

                var result = new BusinessViewJsonResult
                {
                    Success = true,
                };

                return JsonConvert.SerializeObject(result);
            }
        }

        [HttpPost]
        public string AddFeatures(RolesModel model)
        {
            using (var entities = new BViewEntities())
            {
                int roleId = _roleService.AddOrUpdateRole(model);

                var selectedFeatureIds = model.FeatureIds.ToList();

                foreach(var selectedFeatureId in selectedFeatureIds)
                {
                    var feature = new PermissionsBasedOnRole
                    {
                        RoleId = roleId,
                        FeatureId = selectedFeatureId
                    };

                    entities.PermissionsBasedOnRoles.Add(feature);
                    entities.SaveChanges();
                }

                var result = new BusinessViewJsonResult
                {
                    Success = true,
                };

                return JsonConvert.SerializeObject(result);
            }
        }

        //public List<RolesModel> Get()
        //{
        //    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Roles", "Roles Api"));

        //    var rolesList = new List<RolesModel>();

        //    try
        //    {
        //        rolesList = _roleService.GetRolesAndFeatures();
        //    }
        //    catch (Exception ex)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All Roles", "Roles Api", ex.Message));

        //        throw;
        //    }

        //    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Roles", "Roles Api"));

        //    return rolesList;
        //}
    }
}