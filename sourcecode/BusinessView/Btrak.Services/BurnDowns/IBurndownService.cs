using System;
using System.Collections.Generic;
using Btrak.Models.Burndown;

namespace Btrak.Services.BurnDowns
{
    public interface IBurndownService
    {
        string GetBurndownChartHtml(BurnDownChartModel burnDownChartModel);
        string GetD3BurndownChartHtml(List<BurndownModel> burndownModel, int yMax, Guid? companyId);
    }
}