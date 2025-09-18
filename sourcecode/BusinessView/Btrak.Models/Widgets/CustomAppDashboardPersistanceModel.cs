using System;

namespace Btrak.Models.Widgets
{
    public class CustomAppDashboardPersistanceModel
    {
        public Guid? Id { get; set; }

        public Guid DashboardId { get; set; }

        public Guid? CustomApplicationId { get; set; }

        public Guid? CustomFormId { get; set; }

        public Guid? DashboardIdToNavigate { get; set; }

        public string QuerytoFilter { get; set; }
    }
}
