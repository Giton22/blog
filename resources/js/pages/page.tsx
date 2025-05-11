import { type SharedData } from '@/types';
import { Head, usePage } from '@inertiajs/react';

import SkeletonList from './skeletonlist';
import SectionContent from './sectioncontent';
import Header from './header';

export default function Welcome() {
    const { auth } = usePage<SharedData>().props;

    return (
        <>
            <Head title="Welcome">
                <link rel="preconnect" href="https://fonts.bunny.net" />
                <link href="https://fonts.bunny.net/css?family=instrument-sans:400,500,600" rel="stylesheet" />
            </Head>
            <Header auth={auth} />
            <div className="flex h-full flex-1 flex-col gap-6 rounded-xl p-6">
                <div className="flex flex-col gap-3">
                    <div className="flex flex-row gap-6">
                        <SectionContent title="Blog Posts" containerClassName="flex-1">
                            <SkeletonList count={5} />
                        </SectionContent>
                        <SectionContent title="Tags" containerClassName="w-1/6">
                            <SkeletonList count={5} />
                        </SectionContent>
                    </div>
                </div>
            </div>
        </>
    );
}
