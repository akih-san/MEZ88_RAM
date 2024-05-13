#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=../src/boards/MEZ8847Q_RAM.c ../src/I2C_IO.c ../src/io_cpm.c ../src/io_dos.c ../src/memtst.c ../src/mez88_47Q_main.c ../drivers/diskio.c ../fatfs/ff.c ../drivers/utils.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1 ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1 ${OBJECTDIR}/_ext/1360937237/io_cpm.p1 ${OBJECTDIR}/_ext/1360937237/io_dos.p1 ${OBJECTDIR}/_ext/1360937237/memtst.p1 ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1 ${OBJECTDIR}/_ext/239857660/diskio.p1 ${OBJECTDIR}/_ext/2116833129/ff.p1 ${OBJECTDIR}/_ext/239857660/utils.p1
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1.d ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1.d ${OBJECTDIR}/_ext/1360937237/io_cpm.p1.d ${OBJECTDIR}/_ext/1360937237/io_dos.p1.d ${OBJECTDIR}/_ext/1360937237/memtst.p1.d ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1.d ${OBJECTDIR}/_ext/239857660/diskio.p1.d ${OBJECTDIR}/_ext/2116833129/ff.p1.d ${OBJECTDIR}/_ext/239857660/utils.p1.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1 ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1 ${OBJECTDIR}/_ext/1360937237/io_cpm.p1 ${OBJECTDIR}/_ext/1360937237/io_dos.p1 ${OBJECTDIR}/_ext/1360937237/memtst.p1 ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1 ${OBJECTDIR}/_ext/239857660/diskio.p1 ${OBJECTDIR}/_ext/2116833129/ff.p1 ${OBJECTDIR}/_ext/239857660/utils.p1

# Source Files
SOURCEFILES=../src/boards/MEZ8847Q_RAM.c ../src/I2C_IO.c ../src/io_cpm.c ../src/io_dos.c ../src/memtst.c ../src/mez88_47Q_main.c ../drivers/diskio.c ../fatfs/ff.c ../drivers/utils.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=18F47Q84
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1: ../src/boards/MEZ8847Q_RAM.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/423027577" 
	@${RM} ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1.d 
	@${RM} ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1 ../src/boards/MEZ8847Q_RAM.c 
	@-${MV} ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.d ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/I2C_IO.p1: ../src/I2C_IO.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1 ../src/I2C_IO.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/I2C_IO.d ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/io_cpm.p1: ../src/io_cpm.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/io_cpm.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/io_cpm.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/io_cpm.p1 ../src/io_cpm.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/io_cpm.d ${OBJECTDIR}/_ext/1360937237/io_cpm.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/io_cpm.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/io_dos.p1: ../src/io_dos.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/io_dos.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/io_dos.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/io_dos.p1 ../src/io_dos.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/io_dos.d ${OBJECTDIR}/_ext/1360937237/io_dos.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/io_dos.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/memtst.p1: ../src/memtst.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/memtst.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/memtst.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/memtst.p1 ../src/memtst.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/memtst.d ${OBJECTDIR}/_ext/1360937237/memtst.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/memtst.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1: ../src/mez88_47Q_main.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1 ../src/mez88_47Q_main.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.d ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/239857660/diskio.p1: ../drivers/diskio.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/239857660" 
	@${RM} ${OBJECTDIR}/_ext/239857660/diskio.p1.d 
	@${RM} ${OBJECTDIR}/_ext/239857660/diskio.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/239857660/diskio.p1 ../drivers/diskio.c 
	@-${MV} ${OBJECTDIR}/_ext/239857660/diskio.d ${OBJECTDIR}/_ext/239857660/diskio.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/239857660/diskio.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/2116833129/ff.p1: ../fatfs/ff.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/2116833129" 
	@${RM} ${OBJECTDIR}/_ext/2116833129/ff.p1.d 
	@${RM} ${OBJECTDIR}/_ext/2116833129/ff.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/2116833129/ff.p1 ../fatfs/ff.c 
	@-${MV} ${OBJECTDIR}/_ext/2116833129/ff.d ${OBJECTDIR}/_ext/2116833129/ff.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/2116833129/ff.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/239857660/utils.p1: ../drivers/utils.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/239857660" 
	@${RM} ${OBJECTDIR}/_ext/239857660/utils.p1.d 
	@${RM} ${OBJECTDIR}/_ext/239857660/utils.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/239857660/utils.p1 ../drivers/utils.c 
	@-${MV} ${OBJECTDIR}/_ext/239857660/utils.d ${OBJECTDIR}/_ext/239857660/utils.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/239857660/utils.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
else
${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1: ../src/boards/MEZ8847Q_RAM.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/423027577" 
	@${RM} ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1.d 
	@${RM} ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1 ../src/boards/MEZ8847Q_RAM.c 
	@-${MV} ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.d ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/423027577/MEZ8847Q_RAM.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/I2C_IO.p1: ../src/I2C_IO.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1 ../src/I2C_IO.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/I2C_IO.d ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/I2C_IO.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/io_cpm.p1: ../src/io_cpm.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/io_cpm.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/io_cpm.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/io_cpm.p1 ../src/io_cpm.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/io_cpm.d ${OBJECTDIR}/_ext/1360937237/io_cpm.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/io_cpm.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/io_dos.p1: ../src/io_dos.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/io_dos.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/io_dos.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/io_dos.p1 ../src/io_dos.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/io_dos.d ${OBJECTDIR}/_ext/1360937237/io_dos.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/io_dos.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/memtst.p1: ../src/memtst.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/memtst.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/memtst.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/memtst.p1 ../src/memtst.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/memtst.d ${OBJECTDIR}/_ext/1360937237/memtst.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/memtst.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1: ../src/mez88_47Q_main.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360937237" 
	@${RM} ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1 ../src/mez88_47Q_main.c 
	@-${MV} ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.d ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360937237/mez88_47Q_main.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/239857660/diskio.p1: ../drivers/diskio.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/239857660" 
	@${RM} ${OBJECTDIR}/_ext/239857660/diskio.p1.d 
	@${RM} ${OBJECTDIR}/_ext/239857660/diskio.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/239857660/diskio.p1 ../drivers/diskio.c 
	@-${MV} ${OBJECTDIR}/_ext/239857660/diskio.d ${OBJECTDIR}/_ext/239857660/diskio.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/239857660/diskio.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/2116833129/ff.p1: ../fatfs/ff.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/2116833129" 
	@${RM} ${OBJECTDIR}/_ext/2116833129/ff.p1.d 
	@${RM} ${OBJECTDIR}/_ext/2116833129/ff.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/2116833129/ff.p1 ../fatfs/ff.c 
	@-${MV} ${OBJECTDIR}/_ext/2116833129/ff.d ${OBJECTDIR}/_ext/2116833129/ff.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/2116833129/ff.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/239857660/utils.p1: ../drivers/utils.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/239857660" 
	@${RM} ${OBJECTDIR}/_ext/239857660/utils.p1.d 
	@${RM} ${OBJECTDIR}/_ext/239857660/utils.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/_ext/239857660/utils.p1 ../drivers/utils.c 
	@-${MV} ${OBJECTDIR}/_ext/239857660/utils.d ${OBJECTDIR}/_ext/239857660/utils.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/239857660/utils.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -mdebugger=none  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto        $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
	@${RM} ${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.hex 
	
	
else
${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=0 -Wa,-a -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-download -mno-default-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/MEZ88Q8X.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
	
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
