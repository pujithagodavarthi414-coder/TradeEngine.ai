using System.Collections.Generic;

namespace Btrak.Models.TestRail
{
    public class ImportTestSuiteCasesModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public List<ImportSectionModel> Sections { get; set; }
    }

    public class ImportSectionModel
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public List<ImportCaseModel> Cases { get; set; }
    }

    public class ImportCaseModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Template { get; set; }
        public string Type { get; set; }
        public string Priority { get; set; }
        public int Estimate { get; set; }
        public string References { get; set; }
        public ImportCaseCustomModel Customs { get; set; }
    }

    public class ImportCaseCustomModel
    {
        public DropdownModel AutomationType { get; set; }
        public string Preconds { get; set; }
        public ImportTestCaseStepsSeperated Steps_separated { get; set; }
    }

    public class ImportTestCaseStepsSeperated
    {
        public List<ImportTestCaseSteps> Step { get; set; }
    }

    public class ImportTestCaseSteps
    {
        public int Index { get; set; }
        public string Content { get; set; }
        public string Expected { get; set; }
    }
}
