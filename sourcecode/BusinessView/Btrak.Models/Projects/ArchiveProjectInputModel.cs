using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Projects
{
    public class ArchiveProjectInputModel : InputModelBase
    {
        public ArchiveProjectInputModel() : base(InputTypeGuidConstants.ArchieveUserStoryInputCommandTypeGuid)
        {
        }

        public Guid? ProjectId { get; set; }
        public bool IsArchive { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", IsArchive = " + IsArchive);
            stringBuilder.Append(", TimeZone = " + TimeZone);
            return stringBuilder.ToString();
        }
    }
}
