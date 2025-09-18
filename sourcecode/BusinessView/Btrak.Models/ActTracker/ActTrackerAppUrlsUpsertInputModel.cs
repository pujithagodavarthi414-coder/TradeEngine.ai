using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerAppUrlsUpsertInputModel : InputModelBase
    {
        public ActTrackerAppUrlsUpsertInputModel() : base(InputTypeGuidConstants.ActTrackerAppUrlsUpsertInputCommandTypeGuid)
        {
        }
        public Guid? AppUrlNameId { get; set; }
        public Guid? AppUrlTypeId { get; set; }
        public string AppUrlName { get; set; }
        public bool? IsProductive { get; set; }
        public bool? IsApp { get; set; }
        public bool? IsArchive { get; set; }
        public List<Guid?> RoleIds { get; set; }
        public List<Guid?> ProductiveRoleIds { get; set; }
        public List<Guid?> UnproductiveRoleIds { get; set; }
        public List<Guid?> ConfiguredIds { get; set; }
        public string RoleIdXml { get; set; }
        public string ProductiveRoleIdsXml { get; set; }
        public string UnProductiveRoleIdsXml { get; set; }
        public string AppUrlImage { get; set; }
        public Guid? ApplicationCategoryId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AppUrlNameId = " + AppUrlNameId);
            stringBuilder.Append(", AppUrlTypeId = " + AppUrlTypeId);
            stringBuilder.Append(", AppUrlName = " + AppUrlName);
            stringBuilder.Append(", IsProductive = " + IsProductive);
            stringBuilder.Append(", IsApp = " + IsApp);
            stringBuilder.Append(", IsArchive = " + IsArchive);
            stringBuilder.Append(", AppUrlImage = " + AppUrlImage);
            return stringBuilder.ToString();
        }
    }
}
