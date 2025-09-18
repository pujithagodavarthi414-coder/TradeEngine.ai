using System;
using System.Collections.Generic;

namespace Btrak.Models.Widgets
{
    public class DynamicDashboardFilterModel
    {
        public Guid? ReferenceId { get; set; }

        public Guid? DashboardId { get; set; }

        public Guid? DashboardAppId { get; set; }

        public List<FilterKeyValuePair> Filters { get; set; }

        public string FiltersXml { get; set; }
        public bool? IsMongoQuery { get; set; }
        public string CollectionName { get; set; }
    }

    public class FilterKeyValuePair
    {
        public Guid? FilterId { get; set; }

        public string FilterKey { get; set; }

        public string FilterName { get; set; }

        public string FilterValue { get; set; }

        public bool IsSystemFilter { get; set; }
        public Guid? DashboardId { get; set; }
        public Guid? DashboardAppId { get; set; }
    }
}
