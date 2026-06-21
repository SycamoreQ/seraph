#include <signal.h>
#include <stdint.h>
#include <ucontext.h>
#include <stdio.h>
#include <dlfcn.h>
#include <unistd.h>

/*
install a signal handler that fires the instant a guard page gets touched,
captures exactly where and what happened, and gets that information back out to the parent process before the child dies —
since once the process is gone,
that information is gone with it unless you've already shipped it somewhere durable.
 */

void write_str(const char *str) {
    int len = 0;
    while (str[len]) len++;
    write(STDERR_FILENO, str, len);
}

void write_hex(uintptr_t val) {
    char buf[32];
    int i = 0;
    buf[i++] = '\n';
    if (val == 0) {
        buf[i++] = '0';
    } else {
        while (val > 0) {
            int digit = val % 16;
            buf[i++] = (digit < 10) ? ('0' + digit) : ('a' + (digit - 10));
            val /= 16;
        }
    }
    buf[i++] = 'x';
    buf[i++] = '0';
    while (i > 0) {
        write(STDERR_FILENO, &buf[--i], 1);
    }
}

void handler(int sig, siginfo_t *info, void *context) {
    ucontext_t *uc = (ucontext_t *)context;
    uintptr_t pc = 0;

    #if defined(__x86_64__)
        pc = (uintptr_t)uc->uc_mcontext.gregs[REG_RIP];
    #elif defined(__i386__)
        pc = (uintptr_t)uc->uc_mcontext.gregs[REG_EIP];
    #elif defined(__aarch64__)
        pc = (uintptr_t)uc->uc_mcontext->__ss.__pc;
    #elif defined(__arm__)
        pc = (uintptr_t)uc->uc_mcontext.arm_pc;
    #endif

    write_str("\n--- CRASH DUMP CRITICAL ---\n");
    write_str("Faulting Address (si_addr): ");
    write_hex((uintptr_t)info->si_addr);

    write_str("Instruction Pointer (PC)  : ");
    write_hex(pc);

    Dl_info dli;
    if (dladdr((void *)pc, &dli) != 0) {
        write_str("\n--- RESOLVED SYMBOL LOCATION ---\n");

        write_str("Shared Object File: ");
        if (dli.dli_fname) write_str(dli.dli_fname);
        else write_str("Unknown File");

        write_str("\nNearest Function   : ");
        if (dli.dli_sname) write_str(dli.dli_sname);
        else write_str("[Hidden / Static Function]");

        write_str("\nBase Memory Offset: ");
        write_hex((uintptr_t)dli.dli_saddr);

        uintptr_t offset = pc - (uintptr_t)dli.dli_saddr;
        write_str("\nOffset into function: ");
        write_hex(offset);

    } else {
        write_str("\n[Symbol Lookup Failed: Address not mapped inside an ELF object]");
    }

    write_str("\n---------------------------\n");
    _exit(1);
}

int main(void) {
    struct sigaction act = {0};
    act.sa_sigaction = handler;
    act.sa_flags = SA_SIGINFO;

    sigaction(SIGSEGV, &act, NULL);
    sigaction(SIGBUS, &act, NULL);

    // Intentionally cause a segmentation violation
    int *bad_ptr = NULL;
    *bad_ptr = 0xDEAD;

    return 0;
}
