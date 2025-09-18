using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class DashboardSpEntity
    {
        public Guid ProjectId { get; set; }

        public Guid GoalId { get; set; }
        public string GoalName { get; set; }

        public Guid GoalResponsibleUserId { get; set; }
        public string GoalResponsibleUserName { get; set; }

        public string GoalStatusColor { get; set; }
        public DateTime? MileStone { get; set; }
        public int Delay { get; set; }
        public string DelayColor { get; set; }

        public int DashboardId { get; set; }

        public DateTime? OnBoardProcessDate { get; set; }

        public DateTime? CreatedDate { get; set; }
    }

    public class ColorCodeSpEntity
    {
        public Guid Id { get; set; }
        public string StatusName { get; set; }
        public string HexaValue { get; set; }
    }
}
