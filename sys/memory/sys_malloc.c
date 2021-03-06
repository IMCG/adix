#include <sys/memory/sys_malloc.h>
#include <sys/memory/mm_struct.h>
#include <sys/memory/page_table_helper.h>
#include <sys/scheduler/scheduler.h>

void* sys_malloc(uint64_t size) {

    struct list_head *vma_list_head;

    struct pcb_t *currTask = getCurrentTask();
    if(!currTask) {
        vma_list_head = &(get_kernel_mm()->mmap);
    } else {
        vma_list_head = &(currTask->mm->mmap);
    }

    return (void*) mmap(vma_list_head, MALLOC_START_ADDR, size,
                            PAGE_TRANS_READ_WRITE | PAGE_TRANS_USER_SUPERVISOR,
                                                        MAP_ANONYMOUS, 0, 0);

}

void sys_free(void *ptr) {
    struct list_head *vma_list_head;

    struct pcb_t *currTask = getCurrentTask();
    if(!currTask) {
        vma_list_head = &(get_kernel_mm()->mmap);
    } else {
        vma_list_head = &(currTask->mm->mmap);
    }

    munmap(vma_list_head, (uint64_t)ptr);
}

