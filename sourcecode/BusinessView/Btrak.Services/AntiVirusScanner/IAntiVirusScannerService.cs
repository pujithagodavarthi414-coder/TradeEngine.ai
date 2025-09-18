using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.AntiVirusScanner
{
    public interface IAntiVirusScannerService
    {
        Task<bool> IsPotentiallyContainingVirus(Stream inputStream);
    }
}
