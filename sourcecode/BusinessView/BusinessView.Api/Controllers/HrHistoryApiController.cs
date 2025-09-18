using BusinessView.Common;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace BusinessView.Api.Controllers
{
    public class HrHistoryApiController : ApiController
    {
        private readonly IEmployeeService _employeeservice;

        public HrHistoryApiController()
        {
            _employeeservice = new EmployeeService();
        }


        public IList<HRHistorydetails> GetHrHistoryDetails(int username, string fromdate, string todate)
        {
            LoggingManager.Debug("Entering into get hr history details in HR History controller.cs");
          
            try
            {

                
                var list = _employeeservice.GetHrHistorylist(username, fromdate, todate);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All HRList", "HRHistory Api"));

                return list;
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All HRList", "HRHistory Api", ex.Message));

                throw;
            }

        }
    }
}
