# This is as script to prepare Fermi 2FHL all sky data

# Basic analysis Parameters
EMIN=50000
EMAX=2000000
ZMAX=105
EVENT_CLASS=128
EVENT_TYPE=3
IRF=P8R2_SOURCE_V6 # Corresponding to event type 128
EBINALG=LOG
NEBINS=17

# Time cuts taken from reference event list, another reference is missing.
TMIN=239557702.597728
TMAX=444440996.314882

# Raw data files
EVENTS_LIST=$FERMI_FT1_FILE # Fermi FT1 file environment variable
SPACECRAFT=$FERMI_FT2_FILE # Fermi FT2 file environment variable

# Data files
EVENTS=fermi_2fhl_events.fits
EVENTS_SELECTED=fermi_2fhl_events_selected.fits
LIVETIME=fermi_2fhl_livetime.fits
EXPOSURE=fermi_2fhl_exposure_cube_hpx.fits
COUNTS=fermi_2fhl_counts_cube_hpx.fits
PSF=fermi_2fhl_psf_gc.fits

# # Merge weekly photon files and apply energy cut
# gtselect infile=$EVENTS_LIST outfile=$EVENTS_SELECTED ra=0 dec=0 rad=180 \
#          tmin=$TMIN tmax=$TMAX emin=$EMIN emax=$EMAX zmax=$ZMAX \
#          evclass=$EVENT_CLASS evtype=$EVENT_TYPE

# # Update GTI list
# gtmktime scfile=$SPACECRAFT filter="(DATA_QUAL>0)&&(LAT_CONFIG==1)" \
#          roicut=no evfile=$EVENTS_SELECTED outfile=$EVENTS

# # # Compute livetime cube
# # gtltcube zmax=$ZMAX evfile=$EVENTS_SELECTED_GTI scfile=$SPACECRAFT \
# #          outfile=$LIVETIME dcostheta=0.025 binsz=1

# Counts cube
gtbin evfile=$EVENTS outfile=$COUNTS algorithm=HEALPIX SCFILE=$SPACECRAFT \
      coordsys=GAL hpx_ordering_scheme=RING hpx_order=5 hpx_ebin=true ebinalg=LOG \
      emin=$EMIN emax=$EMAX enumbins=$NEBINS

# Compute exposure cube
gtexpcube2 infile=$LIVETIME outfile=$EXPOSURE irf=$IRF cmap=$COUNTS \
        ebinalg=$EBINALG emin=$EMIN emax=$EMAX enumbins=$NEBINS bincalc=EDGE

# Compute psf cube
gtpsf expcube=$LIVETIME outfile=$PSF irfs=$IRF ra=266.42 dec=-29.01 \
emin=$EMIN emax=$EMAX nenergies=$NEBINS thetamax=10 ntheta=300

# Zip files
# gzip $EVENTS_SELECTED_GTI
# gzip $COUNTS
# gzip $EXPOSURE
# gzip $LIVETIME
# gzip $PSF

