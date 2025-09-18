using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
   public class GetDataSourcesByIdInputModel
    {
        public string FormIds { get; set; }
        public bool IsArchived { get; set; }
        public string CompanyIds { get; set; }
    }
    public class GetDataSourcesByIdOutputModel
    {
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public List<KeysModel> KeySet { get; set; }
    }

    public class KeysModel
    {
        public Guid? Id { get; set; }
        public string Key { get; set; }
        public string Label { get; set; }
        public string Type { get; set; }
        public string Path { get; set; }
    }
}
