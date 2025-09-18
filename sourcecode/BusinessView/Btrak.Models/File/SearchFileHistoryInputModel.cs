using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.File
{
    public class SearchFileHistoryInputModel : SearchCriteriaInputModelBase
    {
        public SearchFileHistoryInputModel() : base(InputTypeGuidConstants.SearchFileHistoryInputCommandTypeGuid)
        {
        }

        public Guid? FileId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("  FileId = " + FileId);
            stringBuilder.Append(",  SearchText = " + SearchText);
            return base.ToString();
        }
    }
}