using System;
using System.Xml.Serialization;

namespace Btrak.Models
{
    public class GoalsViewModel
    {
        public Guid Id
        {
            get;
            set;
        }
        public Guid ProjectId
        {
            get;
            set;
        }

        public Guid GoalId
        {
            get;
            set;
        }

        public string Goal
        {
            get;
            set;
        }

        public string BoardTypeApi
        {
            get;
            set;
        }

        public string OnboardDate
        {
            get;
            set;
        }
       
        [XmlElement(IsNullable = true)]
        public string GoalStatusColor
        {
            get;
            set;
        }

        [XmlElement(IsNullable = true)]
        public string MileStone
        {
            get;
            set;
        }

        public int? Delay
        {
            get;
            set;
        }

        public string DelayColor
        {
            get;
            set;
        }

        public Guid TeamLeadId
        {
            get;
            set;
        }

        public string TeamLead
        {
            get;
            set;
        }

        public int? MaxDashboardId
        {
            get;
            set;
        }
        public string ProjectName
        {
            get;
            set;
        }
    }
}
