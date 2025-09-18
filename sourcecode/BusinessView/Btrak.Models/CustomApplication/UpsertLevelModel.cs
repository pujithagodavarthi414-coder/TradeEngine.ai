using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomApplication
{
    public class UpsertLevelModel : SearchCriteriaInputModelBase
    {
        public UpsertLevelModel() : base(InputTypeGuidConstants.UpsertLevelModel)
        {
        }

        public Guid? Id { get; set; }
        public string Level { get; set; }
        public string LevelName { get; set; }
        public Guid? PdfTemplate { get; set; }
        public string DisplayName { get; set; }
        public string Path { get; set; }
        public string ApiKey { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string Parameters { get; set; }
        public int TotalCount { get; set; }
        public bool? IsArchived { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LevelId = " + Id);
            stringBuilder.Append(", Level = " + Level);
            stringBuilder.Append(", LevelName = " + LevelName);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", Parameters = " + Parameters);
            stringBuilder.Append(", ApiKey = " + ApiKey);
            stringBuilder.Append(", Path = " + Path);
            stringBuilder.Append(", DisplayName = " + DisplayName);
            stringBuilder.Append(", PdfTemplate = " + PdfTemplate);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
    public class UpsertDataLevelKeyConfigurationModel
    {
        public Guid? Id { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public UpsertLevelModel DataJson { get; set; }
        public bool? IsArchived { get; set; }
    }

    public class GetLevelsKeyConfigurationModel
    {
        public Guid? Id { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public bool? IsArchived { get; set; }
    }
}
