# openvdm_sample_data

This repository contains the sample configuration data and raw data files used for testing the OpenVDM project.

## Install

### With a new OpenVDM install (recommended)

The OpenVDM installer (`utils/install-openvdm.sh` in the [openvdm](https://github.com/OceanDataTools/openvdm) repository) can install the sample data. Answer `yes` to:

```
Install sample data?  (no) yes
Root directory for sample data? (/data/sample_data)
Sample data repository? (https://github.com/oceandatatools/openvdm_sample_data)
Sample data branch? (master)
```

This sets up everything the sample transfers use:
- the sample data and its database configuration;
- the sample plugins and the parsers they import;
- Samba shares, rsync daemon modules and a local FTP server for the sample transfers;
- lowering components and the sample lowering.

See the openvdm `INSTALL.md` for details.

### Adding the sample data to an existing install

`install_sample_data.sh` adds the sample data to an OpenVDM install that already exists:

1. Download `install_sample_data.sh`.
2. Run the script as root.
3. In the OpenVDM web UI, run the tasks the script lists when it finishes (Rebuild Cruise Directory, Re-export the OpenVDM Configuration, Rebuild Data Dashboard, etc.).

The script sets up the Samba shares and rsync modules, imports the sample database configuration, and enables the sample plugins and parsers. It doesn't set up the following, so the transfers that need them won't run:
- **the local FTP server**, used by the sample FTP transfers;
- **lowering components**, used by the lowering-level transfers such as ROV_OpenRVDAS. Turn them on with **Show Lowering Components** on the cruise's edit page.

## Sample plugins

The sample data enables three plugins from the openvdm repository, and the parsers each of them imports:

| Plugin | Parsers |
|---|---|
| `em302_plugin.py` | `geotiff_titiler_parser` |
| `openrvdas_plugin.py` | `gga_parser`, `met_parser`, `ssv_parser`, `tsg45_parser`, `twind_parser` |
| `rov_openrvdas_plugin.py` | `comp_pres_parser`, `ctd_parser`, `gga_parser`, `o2_parser`, `paro_parser`, `sprint_parser` |

Both install methods take the parsers from each plugin's `from server.plugins.parsers.<name> import` lines, so they follow the plugins if their imports change.
