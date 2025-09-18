using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Assets
{
    public class AssetsMultipleUpdateReturnModel
    {
        public Guid? AssetId { get; set; }
        public string AssetName { get; set; }
        public string AssetNumber { get; set; }
        public int FailedCount { get; set; }
    }
}
