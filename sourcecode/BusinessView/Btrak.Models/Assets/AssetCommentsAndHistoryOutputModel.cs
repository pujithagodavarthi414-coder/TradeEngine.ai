using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Assets
{
    public class AssetCommentsAndHistoryOutputModel
    {
        public AssetCommentsAndHistoryOutputModel()
        {
            AssetsFieldsChangedList = new List<AssetAuditFieldsHistory>();
        }

        public Guid CreatedByUserId { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }

        public string AssetHistoryJson { get; set; }
        public string Comment { get; set; }
        public Guid AssetHistoryId { get; set; }
        public int TotalCount { get; set; }
        public List<AssetAuditFieldsHistory> AssetsFieldsChangedList { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", FullName = " + FullName);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", AssetsFieldsChangedList = " + AssetsFieldsChangedList);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }

    public class AssetCommentsAndHistoryJsonConvertModel
    {
        public List<AssetAuditFields> AssetsFieldsChangedList { get; set; }
    }
}
