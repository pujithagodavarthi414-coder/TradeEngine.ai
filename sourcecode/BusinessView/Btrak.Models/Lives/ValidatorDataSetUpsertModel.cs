using System;

namespace Btrak.Models.Lives
{
    public class ValidatorDataSetUpsertModel
    {
        public Guid? ValidatorId { get; set; }
        public string Template { get; set; }
        public object FormData { get; set; }
    }
}
