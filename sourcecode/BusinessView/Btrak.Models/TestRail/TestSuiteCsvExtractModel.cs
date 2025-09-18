using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TestRail
{
    public class TestSuiteCsvExtractModel
    {
        public string SuiteName { get; set; }
        public string SectionHierarchy { get; set; }
        public string SectionDescription { get; set; }
        public string Template { get; set; }
        public string Type { get; set; }
        public string Preconditions { get; set; }
        public string Title { get; set; }
        public string StepOrder { get; set; }
        public string StepDescription { get; set; }
        public string StepsExpectedResult { get; set; }
        public string EstimateInSeconds { get; set; }
        public string Priority { get; set; }
        public string AutomationType { get; set; }
        public string References { get; set; }
        public string Mission { get; set; }
        public string Goals { get; set; }
    }

    public class SavedSectionsModel
    {
        public Guid? SectionId { get; set; }
        public string ParentName { get; set; }
        public string SectionName { get; set; }
        public int Level { get; set; }
    }
}
