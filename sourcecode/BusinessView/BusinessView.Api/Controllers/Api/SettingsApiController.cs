using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class SettingsApiController : ApiController
    {
        private readonly ITimesheetService _timesheetService;
        public SettingsApiController()
        {
            _timesheetService = new TimesheetService();
        }

        public List<IpSettings> Get()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All IpAddress", "Settings Api"));

            List<IpSettings> ipAddress;

            try
            {
                ipAddress = _timesheetService.GetAllIpAddress();
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All IpAddress", "Settings Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All IpAddress", "Settings Api"));

            return ipAddress;
        }

        public void Delete(int id)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Delete IpAddress", "Settings Api"));

            try
            {
                _timesheetService.DeleteIpAddress(id);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Delete IpAddress", "Settings Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete IpAddress", "Settings Api"));
        }

        public IpSettings Get(int id)
        {

            IpSettings ipDetails;
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Delete IpAddress", "Settings Api"));

            try
            {
                ipDetails = _timesheetService.GetIpAddress(id);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Delete IpAddress", "Settings Api", ex.Message));

                throw;
            }
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete IpAddress", "Settings Api"));
            return ipDetails;
        }
        

        [HttpPost]
        public string AddIp(IpSettings model)
        {
            if (ModelState.IsValid)
            {
                _timesheetService.AddOrUpdateIpDetails(model);
                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add IP", "settings Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add IP", "settings Api"));

            return JsonConvert.SerializeObject(result2);
        }

        [HttpPut]
        public string UpdateIp(IpSettings model)
        {
            if (ModelState.IsValid)
            {
                _timesheetService.AddOrUpdateIpDetails(model);
                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update IP", "settings Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update IP", "Settings Api"));

            return JsonConvert.SerializeObject(result2);
        }
    }
}
