using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomTags
{
    public class CustomTagsInputModel : InputModelBase
    {
        public CustomTagsInputModel() : base(InputTypeGuidConstants.CustomTagsInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? ReferenceId { get; set; }
        public string Tags { get; set; }
        public string Tag { get; set; }
        public Guid? TagId { get; set; }
        public Guid? ParentTagId { get; set; }
        public string TagsXml { get; set; }
        public CustomTagsInputModel[] TagsList { get; set; }
        public bool? IsForDelete { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", ReferenceId = " + ReferenceId);
            stringBuilder.Append(", Tags = " + Tags);
            return stringBuilder.ToString();
        }
    }
}
