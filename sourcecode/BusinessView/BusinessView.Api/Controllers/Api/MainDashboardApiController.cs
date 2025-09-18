using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using BusinessView.DAL;
using BusinessView.Models;

namespace BusinessView.Api.Controllers.Api
{
    public class MainDashboardApiController : ApiController
    {
        public WorkAllocationModel GetAllocatedWork(DateTime date, int? userId)
        {
            using (var entities = new BViewEntities())
            {
                var workAllocatedDetails = new WorkAllocationModel
                {
                    AllNames = new List<object>(),
                    MaxAllocatedHours = new List<object>(),
                    NotAllocatedHours = new List<object>()
                };

                var list = entities.USP_GetEmployeeAllocatedWorkForAMonth(date, userId).OrderBy(c => c.MaxAllocatedHours).ToList();

                var orderedlist = list.OrderByDescending(item => item.FullName);

                foreach (var x in orderedlist)
                {
                    workAllocatedDetails.AllNames.Add(x.FullName);

                    if (x.IsSupport == "True")
                    {
                        int? supporterHours = 40;
                        workAllocatedDetails.MaxAllocatedHours.Add(supporterHours);
                        int? notAllocatedHours = 0;
                        workAllocatedDetails.NotAllocatedHours.Add(notAllocatedHours);
                    }
                    else
                    {
                        workAllocatedDetails.MaxAllocatedHours.Add(x.MaxAllocatedHours > 40 ? 40 : x.MaxAllocatedHours);
                        int? notAllocatedHours = 40;
                        if (x.MaxAllocatedHours != null)
                        {
                            var hours = x.MaxAllocatedHours > 40 ? 40 : x.MaxAllocatedHours;
                            notAllocatedHours = 40 - hours;
                        }
                        workAllocatedDetails.NotAllocatedHours.Add(notAllocatedHours);
                    }
                }
                return workAllocatedDetails;
            }
        }
    }
}