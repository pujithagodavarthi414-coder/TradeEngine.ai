using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.EntityType
{
    public class EntityRoleFeatureUpsertInputModel : InputModelBase
    {
        public EntityRoleFeatureUpsertInputModel() : base(InputTypeGuidConstants .EntityRoleFeatureUpsertInputCommandTypeGuid)
        {
        }

        public List<Guid> EntityFeatureIds { get; set; }
        public string EntityFeatureIdXml { get; set; }
        public Guid? EntityRoleId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(",EntityFeatureIds = " + EntityFeatureIds);
            stringBuilder.Append(", EntityFeatureIdXml = " + EntityFeatureIdXml);
            stringBuilder.Append(", EntityRoleId = " + EntityRoleId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}