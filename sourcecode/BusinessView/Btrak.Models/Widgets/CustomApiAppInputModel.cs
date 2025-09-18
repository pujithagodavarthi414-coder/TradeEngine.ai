using System;
using System.Collections.Generic;

namespace Btrak.Models.Widgets
{
    public class CustomApiAppInputModel
    {
        public Guid? CustomWidgetId { get; set; }

        public string HttpMethod { get; set; }

        public string OutputRoot { get; set; }

        public string ApiUrl { get; set; }

        public string BodyJson { get; set; }

        public string ApiHeadersJson { get; set; }

        public string ApiOutputsJson { get; set; }

        public Guid? WorkspaceId { get; set; }

        public Guid? DashboardId { get; set; }

        public ApiHeadersModel[] ApiHeaders { get; set; }

        public ApiOutputModel[] OutputParams { get; set; }

        public bool? IsForDashBoard { get; set; }
    }

    public class ApiHeadersModel
    {
        public string Key { get; set; }

        public string Value { get; set; }
    }

    public class ApiOutputModel
    {
        public string Field { get; set; }

        public string Filter { get; set; }
    }

    public class ApiOutputDataModel
    {
        public string ApiData { get; set; }

        public string CustomWidgetName { get; set; }

        public List<CustomAppChartModel> AllChartsDetails { get; set; }
    }
}
