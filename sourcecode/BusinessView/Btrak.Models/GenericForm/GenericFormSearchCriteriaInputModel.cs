using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.GenericForm
{
    public class GenericFormSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GenericFormSearchCriteriaInputModel() : base(InputTypeGuidConstants.GenericFormSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid? FormTypeId { get; set; }
        public string FormName { get; set; }
        public string SearchText { get; set; }
        public new bool IsArchived { get; set; }
        public DateTime ArchivedDateTime { get; set; }
        public int Pagesize { get; set; }
        public int Pagenumber { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public string FormIds { get; set; }
        public string FormIdsXml { get; set; }
        public bool? IsIncludeTemplateForms { get; set; }
        public List<Guid> FormIdsList { get; set; }
        public string CompaniesList { get; set; }
        public bool? IsIncludedAllForms { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", FormTypeId = " + FormTypeId);
            stringBuilder.Append(", FormName = " + FormName);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", Pagesize = " + Pagesize);
            stringBuilder.Append(", Pagenumber = " + Pagenumber);
            return stringBuilder.ToString();
        }
    }
}
