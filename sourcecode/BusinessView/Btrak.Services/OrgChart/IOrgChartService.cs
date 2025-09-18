using Btrak.Models;
using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Models;

namespace Btrak.Services.OrgChart
{
    public interface IOrgChartService
    {
        OrgChartModel GetOrgChart();
        List<OrgChartModel> GetChildrenOfParent(List<EmployeeReportToDbEntity> dependentEmployees);
        Guid GetParentOfOrgChart();
    }
}