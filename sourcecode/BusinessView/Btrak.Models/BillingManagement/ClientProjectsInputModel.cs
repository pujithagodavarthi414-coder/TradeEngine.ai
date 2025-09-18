using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models
{
    public class ClientProjectsInputModel : InputModelBase
    {
        public ClientProjectsInputModel() : base(InputTypeGuidConstants.ClientProjectsInputCommandTypeGuid)
        {
        }

        public Guid? ClientProjectId { get; set; }
        public Guid? ClientId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientProjectId" + ClientProjectId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("IsArchived" + IsArchived);
            return base.ToString();
        }
    }
}