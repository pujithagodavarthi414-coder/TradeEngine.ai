using BTrak.Common;
using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using nClam;

namespace Btrak.Services.AntiVirusScanner
{
    public class AntiVirusScannerService : IAntiVirusScannerService
    {
        public async Task<bool> IsPotentiallyContainingVirus(Stream inputStream)
        {
            try
            {
                if (inputStream == null)
                {
                    return false;
                }

                var preCopyPosition = inputStream.Position;

                using (MemoryStream ms = new MemoryStream())
                {
                    inputStream.CopyTo(ms);

                    inputStream.Position = preCopyPosition;

                    var clamClient = new ClamClient("localhost");

                    var scanResult = await clamClient.SendAndScanFileAsync(ms);

                    switch (scanResult.Result)
                    {
                        case ClamScanResults.Clean:
                            LoggingManager.Info("The file is clean!");
                            return false;

                        case ClamScanResults.VirusDetected:
                            LoggingManager.Error("Virus Found!");
                            LoggingManager.Error($"Virus name: {scanResult.InfectedFiles.First().VirusName}");
                            return true;

                        case ClamScanResults.Error:
                            LoggingManager.Error($"Woah an error occured! Error: {scanResult.RawResult}");
                            return true;
                    }
                }

                return true;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "IsPotentiallyContainingVirus", "AntiVirusScannerService ", exception.Message), exception);

            }
            return true;
        }
    }
}
