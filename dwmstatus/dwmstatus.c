#define _BSD_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <strings.h>
#include <sys/time.h>
#include <time.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <X11/Xlib.h>

char *tzlondon = "Europe/London";

static Display *dpy;

char *smprintf(char *fmt, ...)
{
  va_list fmtargs;
  char *ret;
  int len;

  va_start(fmtargs, fmt);
  len = vsnprintf(NULL, 0, fmt, fmtargs);
  va_end(fmtargs);

  ret = malloc(++len);
  if (ret == NULL) {
    perror("malloc");
    exit(1);
  }

  va_start(fmtargs, fmt);
  vsnprintf(ret, len, fmt, fmtargs);
  va_end(fmtargs);

  return ret;
}

char *readfile(char *base, char *file)
{
  char *path, line[513];
  FILE *fd;

  memset(line, 0, sizeof(line));

  path = smprintf("%s/%s", base, file);
  fd = fopen(path, "r");
  if (fd == NULL)
    return NULL;
  free(path);

  if (fgets(line, sizeof(line)-1, fd) == NULL)
    return NULL;
  fclose(fd);

  return smprintf("%s", line);
}

/*
 * Linux seems to change the filenames after suspend/hibernate
 * according to a random scheme. So just check for both possibilities.
 */
char *getbattery(char *base)
{
  char *co;
  int descap, remcap;

  descap = -1;
  remcap = -1;

  co = readfile(base, "present");
  if (co == NULL || co[0] != '1') {
    if (co != NULL) free(co);
    return smprintf("not present");
  }
  free(co);

  co = readfile(base, "charge_full_design");
  if (co == NULL) {
    co = readfile(base, "energy_full_design");
    if (co == NULL)
      return smprintf("");
  }
  sscanf(co, "%d", &descap);
  free(co);

  co = readfile(base, "charge_now");
  if (co == NULL) {
    co = readfile(base, "energy_now");
    if (co == NULL)
      return smprintf("");
  }
  sscanf(co, "%d", &remcap);
  free(co);

  if (remcap < 0 || descap < 0)
    return smprintf("invalid");

  return smprintf("%.0f", ((float)remcap / (float)descap) * 100);
}


void settz(char *tzname)
{
  setenv("TZ", tzname, 1);
}

char *mktimes(char *fmt, char *tzname)
{
  char buf[129];
  time_t tim;
  struct tm *timtm;

  memset(buf, 0, sizeof(buf));
  settz(tzname);
  tim = time(NULL);
  timtm = localtime(&tim);
  if (timtm == NULL) {
    perror("localtime");
    exit(1);
  }

  if (!strftime(buf, sizeof(buf)-1, fmt, timtm)) {
    fprintf(stderr, "strftime == 0\n");
    exit(1);
  }

  return smprintf("%s", buf);
}

void setstatus(char *str)
{
  XStoreName(dpy, DefaultRootWindow(dpy), str);
  XSync(dpy, False);
}

char *loadavg(void)
{
  double avgs[3];

  if (getloadavg(avgs, 3) < 0) {
    perror("getloadavg");
    exit(1);
  }

  return smprintf("%.2f %.2f %.2f", avgs[0], avgs[1], avgs[2]);
}

int main(void)
{
  char *status;
  char *avgs;
  char *tmlondon;
  char *battery;

  if (!(dpy = XOpenDisplay(NULL))) {
    fprintf(stderr, "dwmstatus: cannot open display.\n");
    return 1;
  }

  for (;;sleep(90)) {
    avgs = loadavg();
    tmlondon = mktimes("KW %W %a %d %b %H:%M %Z %Y", tzlondon);
    battery = getbattery("/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0");
    status = smprintf("C:%s%% L:%s U:%s", battery, avgs, tmlondon);
    setstatus(status);
    free(avgs);
    free(battery);
    free(tmlondon);
    free(status);
  }

  XCloseDisplay(dpy);

  return 0;
}

